import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';
import '../Model/GetTripModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/SuccessModel.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);
  Future<SuccessModel?> loginApi(Map<String, dynamic> data);
  Future<GetTripModel?> getTrip();
  Future<GetPrevousTripModel?> getPrevousTrip();
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
  Future<SuccessModel?> loginApi(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.login}",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('loginApi:${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error loginApi::$e');
      return null;
    }
  }

  @override
  Future<GetTripModel?> getTrip() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getTrip}");
      if (res.statusCode == 200) {
        debugPrint('getTrip:${res.data}');
        return GetTripModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getTrip::$e');
      return null;
    }
  }

  @override
  Future<GetPrevousTripModel?> getPrevousTrip() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getPrevousTrip}");
      if (res.statusCode == 200) {
        debugPrint('getPrevousTrip:${res.data}');
        return GetPrevousTripModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getPrevousTrip::$e');
      return null;
    }
  }
}
