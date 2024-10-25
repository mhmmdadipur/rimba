part of 'controllers.dart';

class TransactionController extends GetxController {
  final ApiService _apiService = ApiService();

  final DatabaseController _databaseController = Get.find();
  final CartController _cartController = Get.find();

  final Rx<int> selectedFilter = Rx<int>(0);
  final Rx<List?> listTransaction = Rx<List?>(null);
  Rx<Map?> detailTransaction = Rx<Map?>(null);

  Future<bool> getListTransaction() async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/transaction';

      var response = await _apiService.getDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        listTransaction(decoded?['data']?['data'] ?? []);
      } else {
        if (listTransaction.isRxNull) listTransaction([]);
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'getListContent',
          url: url,
          method: 'GET',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      if (listTransaction.isRxNull) listTransaction([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (listTransaction.isRxNull) listTransaction([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (listTransaction.isRxNull) listTransaction([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (listTransaction.isRxNull) listTransaction([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> getDetailTransaction({
    required String idTransaction,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/transaction/$idTransaction';

      var response = await _apiService.getDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        detailTransaction(decoded?['data']);
      } else {
        if (detailTransaction.isRxNull) detailTransaction({});
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'getDetailTransaction',
          url: url,
          method: 'GET',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      if (detailTransaction.isRxNull) detailTransaction({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (detailTransaction.isRxNull) detailTransaction({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (detailTransaction.isRxNull) detailTransaction({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (detailTransaction.isRxNull) detailTransaction({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> createTransaction({
    required Map body,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/transaction';

      var response = await _apiService.postDataWithToken(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListTransaction(),
        ]);
        Get.back(result: true);
        _cartController.selectedProducts
            .update((_) => _cartController.selectedProducts = Rx<List>([]));
        SharedWidget.renderDefaultSnackBar(message: '${decoded['message']}');
      } else {
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'createTransaction',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: decoded);

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> updateTransaction({
    required String idTransaction,
    required Map body,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/transaction/$idTransaction';

      var response = await _apiService.putDataWithToken(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListTransaction(),
        ]);
        Get.back(result: true);
        SharedWidget.renderDefaultSnackBar(message: '${decoded['message']}');
      } else {
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'updateTransaction',
          url: url,
          method: 'PUT',
          header: response.headers,
          body: body,
          response: decoded);

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> deleteTransaction({
    required String idTransaction,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/transaction/$idTransaction';

      var response = await _apiService.deleteDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListTransaction(),
        ]);
        Get.back(result: true);
        SharedWidget.renderDefaultSnackBar(message: '${decoded['message']}');
      } else {
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'deleteTransaction',
          url: url,
          method: 'DELETE',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  CustomStatus generateStatusLabel(String? status) {
    if (status != null) {
      return CustomStatus(
        idStatus: 1,
        labelStatus: 'Active',
        colorStatus: Colors.teal.shade700,
      );
    } else if (status == null) {
      return CustomStatus(
        idStatus: 2,
        labelStatus: 'Inactive',
        colorStatus: Colors.red.shade700,
      );
    } else {
      return CustomStatus(
        labelStatus: 'void',
        colorStatus: Colors.black,
      );
    }
  }
}
