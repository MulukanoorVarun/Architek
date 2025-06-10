import 'dart:convert';
import 'dart:io';

import 'package:arkitek_app/models/SuccessModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/ArchitectModel.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<ArchitectModel?> getArchetic();
  Future<SuccessModel?> registerApi(Map<String,dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      if (value is File &&
          (key.contains('image') ||
              key.contains('file') ||
              key.contains('picture') ||
              key.contains('payment_screenshot'))) {
        formMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      } else {
        formMap[key] = value.toString();
      }
    }

    return FormData.fromMap(formMap);
  }

  @override
  Future<SuccessModel?> registerApi(Map<String,dynamic> data) async {
    try {
      Response res = await ApiClient.post("${APIEndpointUrls.register}",data: data);
      if (res.statusCode == 200) {
        debugPrint('registerApi:${res.data}');
        return SuccessModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error registerApi::$e');
      return null;
    }
  }

  @override
  Future<ArchitectModel?> getArchetic() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getarchetic}");
      if (res.statusCode == 200) {
        debugPrint('getArchetic:${res.data}');
        return ArchitectModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getArchetic::$e');
      return null;
    }
  }
}
