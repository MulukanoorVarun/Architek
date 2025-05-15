import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Model/CategoryResponseModel.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';
import 'package:tripfin/Model/GetProfileModel.dart';
import 'package:tripfin/Model/TripsSummaryResponse.dart';
import '../Model/GetTripModel.dart';
import '../Model/LoginResponseModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/SuccessModel.dart';
import '../Model/UpdateProfileModel.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);

  Future<Login_ResponseModel?> loginApi(Map<String, dynamic> data);

  Future<GetTripModel?> getTrip();

  Future<GetPrevousTripModel?> getPrevousTrip();

  Future<GetprofileModel?> getProfiledetails();

  Future<TripsSummaryResponse?> getTripcount();

  Future<Updateprofilemodel?> UpdateProfile(Map<String, dynamic> data);

  Future<Categoryresponsemodel?> getcategory();
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
      debugPrint('Error loginApi::$e');
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
      debugPrint('Error loginApi::$e');
      return null;
    }
  }

  @override
  Future<GetprofileModel?> getProfiledetails() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.userdetail}");
      if (res.statusCode == 200) {
        debugPrint('getProfile:${res.data}');
        return GetprofileModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error ProfileApi::$e');
      return null;
    }
  }

  @override
  Future<TripsSummaryResponse?> getTripcount() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.tripcount}");
      if (res.statusCode == 200) {
        debugPrint('getProfile:${res.data}');
        return TripsSummaryResponse.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error ProfileApi::$e');
      return null;
    }
  }

  Future<Updateprofilemodel?> UpdateProfile(dynamic data) async {
    try {
      print(
        'RemoteDataSource: Sending PUT request to ${APIEndpointUrls.userdetail} with data: $data',
      );
      Response response = await ApiClient.put(
        APIEndpointUrls.userdetail,
        data: data, // Pass FormData directly
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ3ODA2MTA2LCJpYXQiOjE3NDcyMDEzMDYsImp0aSI6IjhlMjM0OGFhZDc1YjQ1NzdhZjRhNmNmNWFmMmE3ZTg4IiwidXNlcl9pZCI6ImEwMzU0YzRlLTVhZjQtNDNmNy1iMzIzLWMyMGQ4NDQ1ODlkZSIsImZ1bGxfbmFtZSI6InNheWVlZCIsImVtYWlsIjoic2F5ZWVkQGdtYWlsLmNvbSIsIm1vYmlsZSI6IjkxMDAxOTk4ODgifQ.Ewd4kVrC399tL_lphVqC7YC_-2yFf_CyNYuBSadMyknXmavOnj1g4jHvrBcqvrpuYhsxaMkZT30YoZfxVID12npKUtuiGCGh0xj_cuVVqZJZoz-EO5mAe8svbXHs79QAT5lnQk2_u-1JCCAN-d7xRyVD5JJhRWasU1kXxwPIJV5OB7IJ0zvrEm7Y_1MLdEYioCXllJ3O0BpyS8rLSE7iS8QJvl-wElsJQRHRpz_czEVm98x8F8wDH7Hz_KobEHppBu8d-USrQLPiYjme6N1e2fw-0kD3nht00QY3jfdCEAXMplLtCoa6s-nwiU99NRNFabtD9s_0oXXunDsXNG2fu6kiZ184t1XfXnHvZy28ouPezUuHm2nai2q9ohofNv5JXKyu-T3MYWMXbeIkYHJG5L6_0mOrV0HVGAnKZFcAi5OcpRd-Sdy5jI2TId5tOgZTQXgjy8XJS4kZ4IC3GnXDQrXQhUJsrH87MtzoKw6330YpH6kkXicJZm6tBkinaBu0Jl52NFHS0V1Bn6p_sv7PLQZzKRnK8hkWqJ4o86trmkQCxUIocTa_8E23eJZMduGxRbp7oEdB0SExDaFWq7N_pInN_G261Abz-q5PnS590PGFol_u90IkXtFglR1QjSkKXvIprST2T6X-BLrYudWgSe38ZdC8P6ThOKdQZP7F0Xw",
          },
        ),
      );

      print('RemoteDataSource: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('RemoteDataSource: Success - ${response.data}');
        return Updateprofilemodel.fromJson(response.data);
      } else {
        print('RemoteDataSource: Failed with status: ${response.statusCode}');
        print('RemoteDataSource: Server error: ${response.data}');
        return null;
      }
    } catch (e) {
      print('RemoteDataSource: Error - $e');
      return null;
    }
  }



  @override
  Future<Categoryresponsemodel?> getcategory() async{
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getcategory}");
      if (res.statusCode == 200) {
        debugPrint('getcategory:${res.data}');
        return Categoryresponsemodel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getcategory::$e');
      return null;
    }
  }
}
