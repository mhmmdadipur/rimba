import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../controllers/controllers.dart';
import '../shared/shared.dart';

class ApiService {
  Future<http.Response> getData(
      {required String url, Map<String, String>? headers}) async {
    headers ??= {};
    headers.addAll({'Accept': 'application/json'});

    http.Response res = await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(minutes: 2));

    return res;
  }

  Future<http.Response> getDataWithToken({
    required String url,
    Map<String, String>? headers,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    headers ??= {};
    headers.addAll({
      'Accept': 'application/json',
      'Authorization': '${prefs.getString('accessToken')}',
    });

    http.Response res = await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(minutes: 2));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> postData({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    headers.addAll({'Accept': 'application/json'});

    http.Response res = await http
        .post(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    return res;
  }

  Future<http.Response> postFormData({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.headers.addAll({'Accept': 'application/json'});
    if (headers != null) request.headers.addAll(headers);

    if (body != null) {
      for (var element in body.entries) {
        if (element.value is File) {
          request.files.add(await http.MultipartFile.fromPath(
              element.key, (element.value as File).path));
        } else if (element.value is List<File>) {
          for (var file in element.value) {
            request.files.add(await http.MultipartFile.fromPath(
                element.key, (file as File).path));
          }
        } else {
          request.fields.addAll({element.key: '${element.value}'});
        }
      }
    }
    http.Response res = await http.Response.fromStream(
        await request.send().timeout(const Duration(minutes: 2)));

    return res;
  }

  Future<http.Response> postDataWithToken({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    headers ??= {};
    headers.addAll({
      'Accept': 'application/json',
      'Authorization': '${prefs.getString('accessToken')}',
    });

    http.Response res = await http
        .post(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> postFormDataWithToken({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.headers.addAll({'Accept': 'application/json'});
    if (headers != null) request.headers.addAll(headers);

    request.headers.addAll({
      'Authorization': '${prefs.getString('accessToken')}',
    });

    if (body != null) {
      for (var element in body.entries) {
        if (element.value is File) {
          request.files.add(await http.MultipartFile.fromPath(
              element.key, (element.value as File).path));
        } else if (element.value is List<File>) {
          for (var file in element.value) {
            request.files.add(await http.MultipartFile.fromPath(
                element.key, (file as File).path));
          }
        } else {
          request.fields.addAll({element.key: '${element.value}'});
        }
      }
    }
    http.Response res = await http.Response.fromStream(
        await request.send().timeout(const Duration(minutes: 2)));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> putData({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    headers.addAll({'Accept': 'application/json'});

    http.Response res = await http
        .put(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    return res;
  }

  Future<http.Response> putDataWithToken({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    headers ??= {};
    headers.addAll({
      'Accept': 'application/json',
      'Authorization': '${prefs.getString('accessToken')}',
    });

    http.Response res = await http
        .put(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> putFormData({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    var request = http.MultipartRequest("PUT", Uri.parse(url));

    request.headers.addAll({'Accept': 'application/json'});
    if (headers != null) request.headers.addAll(headers);

    if (body != null) {
      for (var element in body.entries) {
        if (element.value is File) {
          request.files.add(await http.MultipartFile.fromPath(
              element.key, (element.value as File).path));
        } else if (element.value is List<File>) {
          for (var file in element.value) {
            request.files.add(await http.MultipartFile.fromPath(
                element.key, (file as File).path));
          }
        } else {
          request.fields.addAll({element.key: '${element.value}'});
        }
      }
    }
    http.Response res = await http.Response.fromStream(
        await request.send().timeout(const Duration(minutes: 2)));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> putFormDataWithToken({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest("PUT", Uri.parse(url));

    if (headers != null) request.headers.addAll(headers);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': '${prefs.getString('accessToken')}',
    });
    if (body != null) {
      for (var element in body.entries) {
        if (element.value is File) {
          request.files.add(await http.MultipartFile.fromPath(
              element.key, (element.value as File).path));
        } else if (element.value is List<File>) {
          for (var file in element.value) {
            request.files.add(await http.MultipartFile.fromPath(
                element.key, (file as File).path));
          }
        } else {
          request.fields.addAll({element.key: '${element.value}'});
        }
      }
    }
    http.Response res = await http.Response.fromStream(
        await request.send().timeout(const Duration(minutes: 2)));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }

  Future<http.Response> deleteData({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    headers.addAll({'Accept': 'application/json'});

    http.Response res = await http
        .delete(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    return res;
  }

  Future<http.Response> deleteDataWithToken({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    headers ??= {};
    headers.addAll({
      'Accept': 'application/json',
      'Authorization': '${prefs.getString('accessToken')}',
    });

    http.Response res = await http
        .delete(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(minutes: 2));

    if (res.statusCode == 401) {
      var response = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.logout,
          title: 'Expired Token',
          backgroundIconColor: Colors.red,
          contentText: 'Your token has expired, please re-login');

      if (response != null) {
        Get.find<UserController>().logout(isForceLogout: true);
      }
      return res;
    } else {
      return res;
    }
  }
}
