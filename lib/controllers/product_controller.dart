part of 'controllers.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  final DatabaseController _databaseController = Get.find();

  final Rx<int> selectedFilter = Rx<int>(0);
  final Rx<List?> listProduct = Rx<List?>(null);
  Rx<Map?> detailProduct = Rx<Map?>(null);

  Future<bool> getListProduct() async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product';

      var response = await _apiService.getDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        listProduct(decoded?['data']?['data'] ?? []);
      } else {
        if (listProduct.isRxNull) listProduct([]);
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
      if (listProduct.isRxNull) listProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (listProduct.isRxNull) listProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (listProduct.isRxNull) listProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (listProduct.isRxNull) listProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> getDetailProduct({
    required String idProduct,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product/$idProduct';

      var response = await _apiService.getDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        detailProduct(decoded?['data']);
      } else {
        if (detailProduct.isRxNull) detailProduct({});
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'getDetailProduct',
          url: url,
          method: 'GET',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      if (detailProduct.isRxNull) detailProduct({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (detailProduct.isRxNull) detailProduct({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (detailProduct.isRxNull) detailProduct({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (detailProduct.isRxNull) detailProduct({});
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> createProduct({
    required Map body,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product';

      var response = await _apiService.postDataWithToken(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListProduct(),
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
          title: 'createProduct',
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

  Future<bool> updateProduct({
    required String idProduct,
    required Map body,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product/$idProduct';

      var response = await _apiService.putDataWithToken(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListProduct(),
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
          title: 'updateProduct',
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

  Future<bool> deleteProduct({
    required String idProduct,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product/$idProduct';

      var response = await _apiService.deleteDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        await Future.wait([
          getListProduct(),
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
          title: 'deleteProduct',
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
