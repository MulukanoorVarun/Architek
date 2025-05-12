import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'Model/LoginResponseModel.dart';
import 'Model/RegisterModel.dart';
import 'Model/SuccessModel.dart';
import 'Services/ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);
  Future<Login_ResponseModel?> loginApi(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<RegisterModel?> registerApi(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.register}",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('registerApi:${response.data}');
        return RegisterModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error registerApi::$e');
      return null;
    }
  }

  @override
  Future<Login_ResponseModel?> loginApi(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.login}",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('loginApi:${response.data}');
        return Login_ResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error loginApi::$e');
      return null;
    }
  }
}
