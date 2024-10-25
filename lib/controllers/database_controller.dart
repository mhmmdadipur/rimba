part of 'controllers.dart';

class DatabaseController extends GetxController {
  final ThemeController _themeController = Get.find();

  final String _databaseName = 'app.db';
  final int _databaseVersion = 3;

  Database? _database;

  @override
  void onInit() {
    super.onInit();
    if (_themeController.isMobile) _initialization();
  }

  Future<Database> _initialization() async {
    if (_database != null) return _database!;

    final Directory dbPath = await getApplicationDocumentsDirectory();
    String path = join(dbPath.path, _databaseName);
    _database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);

    debugPrint('Version DB: ${await _database?.getVersion()}');
    debugPrint('Created DB at $path');

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''CREATE TABLE logs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          isDone REAL NOT NULL DEFAULT true,
          title TEXT NOT NULL,
          url TEXT NOT NULL,
          method TEXT NOT NULL DEFAULT '',
          header TEXT NOT NULL DEFAULT '', 
          body TEXT NOT NULL DEFAULT '',
          response TEXT NOT NULL DEFAULT '',
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
          )''');
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      for (var i = oldVersion; i < newVersion; i++) {
        switch (i) {
          case 1: //Update Version: 1 -> 2
            await db.execute(
                "ALTER TABLE logs ADD COLUMN header TEXT NOT NULL DEFAULT ''");
            await db.execute(
                "ALTER TABLE logs ADD COLUMN body TEXT NOT NULL DEFAULT ''");
            debugPrint('Updated to version 2');
            break;
          case 2: //Update Version: 2 -> 3
            await db.execute(
                "ALTER TABLE logs ADD COLUMN method TEXT NOT NULL DEFAULT ''");
            debugPrint('Updated to version 3');
            break;
        }
      }
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return;
    }
  }

  Future<List> getColumnTable(String tableName) async {
    try {
      final database = await _initialization();

      List<Map> response =
          await database.rawQuery('PRAGMA table_info($tableName)');

      List result = response.map((e) => e['name']).toList();
      debugPrint('$result');

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return [];
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<CustomDataLog?> createLog({
    required bool isDone,
    required String title,
    required String url,
    required String method,
    required Map header,
    required Map body,
    required Map response,
  }) async {
    try {
      if (!_themeController.isMobile) return null;

      if (!_themeController.historyLog.value) return null;

      final database = await _initialization();

      body.forEach((key, value) => body[key] = value.toString());

      Map<String, Object> log = {
        'isDone': isDone ? 1 : 0,
        'title': title,
        'url': url,
        'method': method,
        'header': jsonEncode(header),
        'body': jsonEncode(body),
        'response': jsonEncode(response),
        'createdAt': '${DateTime.now()}',
        'updatedAt': '${DateTime.now()}',
      };

      int id = await database.insert('logs', log,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return CustomDataLog.fromJson(log).copyWith(id: id);
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return null;
    }
  }

  Future<CustomDataLog?> updateLog(CustomDataLog value) async {
    try {
      if (!_themeController.isMobile) return null;

      if (!_themeController.historyLog.value) return null;

      final database = await _initialization();

      int id = await database.update('logs', value.toJson(),
          where: 'id = ?',
          whereArgs: [value.id],
          conflictAlgorithm: ConflictAlgorithm.replace);

      return value.copyWith(id: id);
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return null;
    }
  }

  Future<List<CustomDataLog>> readAllLog() async {
    try {
      if (!_themeController.isMobile) return [];

      final database = await _initialization();

      final data = await database.query('logs', orderBy: 'createdAt ASC');
      List<CustomDataLog> result =
          data.map((e) => CustomDataLog.fromJson(e)).toList();
      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return [];
    }
  }

  Future<CustomDataLog?> readLog(int id) async {
    try {
      if (!_themeController.isMobile) return null;

      final database = await _initialization();

      final data =
          await database.query('logs', where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return CustomDataLog.fromJson(data.first);
      } else {
        return null;
      }
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return null;
    }
  }

  Future<int> deleteLog(int id) async {
    try {
      if (!_themeController.isMobile) return 0;

      final database = await _initialization();

      return await database.delete('logs', where: 'id = ?', whereArgs: [id]);
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return 0;
    }
  }

  Future<bool> clearLog() async {
    try {
      if (!_themeController.isMobile) return false;

      final database = await _initialization();
      await database.execute('DELETE FROM logs');

      SharedWidget.renderDefaultSnackBar(
          message: 'Table logs have been successfully cleared');

      return true;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry!', message: e.message, isError: true);
      return false;
    }
  }
}
