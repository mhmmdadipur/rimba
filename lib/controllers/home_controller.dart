part of 'controllers.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  final DatabaseController _databaseController = Get.find();

  final Rx<List?> dashboardProduct = Rx<List?>(null);

  Future<bool> getDashboardProduct() async {
    try {
      /// Declare variable
      bool result = false;
      String url = '${SharedValue.baseUrl}/product';

      var response = await _apiService.getDataWithToken(url: url);

      dynamic decoded = jsonDecode(response.body);

      if (decoded['success']) {
        dashboardProduct(decoded?['data']?['data'] ?? []);
      } else {
        if (dashboardProduct.isRxNull) dashboardProduct([]);
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'getDashboardProduct',
          url: url,
          method: 'GET',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      if (dashboardProduct.isRxNull) dashboardProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (dashboardProduct.isRxNull) dashboardProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (dashboardProduct.isRxNull) dashboardProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (dashboardProduct.isRxNull) dashboardProduct([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }
}
