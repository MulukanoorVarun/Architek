import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';
import 'package:tripfin/Model/PiechartExpenceModel.dart';
import '../Model/CategoryResponseModel.dart';
import '../Model/ExpenseDetailModel.dart';
import '../Model/GetCurrencyModel.dart';
import '../Model/GetProfileModel.dart';
import '../Model/GetTripModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/SuccessModel.dart';
import '../Model/TripsSummaryResponse.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';
import 'package:http/http.dart' as http;


abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);
  Future<SuccessModel?> loginApi(Map<String, dynamic> data);
  Future<GetTripModel?> getTrip();
  Future<GetPrevousTripModel?> getPrevousTrip();
  Future<GetprofileModel?> getProfiledetails();
  Future<TripsSummaryResponse?> getTripcount();
  Future<Categoryresponsemodel?> getcategory();
  Future<ExpenseDetailModel?> getExpenseDetails(String id);
  Future<GetCurrencyModel?> getCurrency();
  Future<SuccessModel?> postExpense(Map<String, dynamic> data);
  Future<Piechartexpencemodel?> Piechartdata();
  Future<SuccessModel?> updateExpensedata(Map<String, dynamic> data);
  Future<SuccessModel?> deleteExpenseDetails(String id);
  Future<SuccessModel?> postTrip(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {

  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;
      final isFile =
          value is String &&
              value.contains('/') &&
              (key.contains('image') || key.contains('file') || key.contains('picture') || key.contains('payment_screenshot'));

      if (isFile) {
        formMap[key] = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
      } else {
        formMap[key] = value;
      }
    }

    return FormData.fromMap(formMap);
  }

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
      Response res = await ApiClient.get("${APIEndpointUrls.getPreviousTrip}");
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

  @override
  Future<Categoryresponsemodel?> getcategory() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getCategory}");
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

  @override
  Future<ExpenseDetailModel?> getExpenseDetails(String id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.getExpenseDetails}/${id}",
      );
      if (res.statusCode == 200) {
        debugPrint('getExpenseDetails:${res.data}');
        return ExpenseDetailModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getExpenseDetails::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> deleteExpenseDetails(String id) async {
    try {
      Response res = await ApiClient.delete(
        "${APIEndpointUrls.deleteExpenseDetails}/${id}",
      );
      if (res.statusCode == 200) {
        debugPrint('deleteExpenseDetails:${res.data}');
        return SuccessModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error deleteExpenseDetails::$e');
      return null;
    }
  }

  @override
  Future<GetCurrencyModel?> getCurrency() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getCurrency}");
      if (res.statusCode == 200) {
        debugPrint('getCurrency:${res.data}');
        return GetCurrencyModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getCurrency::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> postExpense(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.postExpence,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('postExpense: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error postExpense: $e');
      return null;
    }
  }

  // @override
  // Future<SuccessModel?> postTrip(Map<String, dynamic> data) async {
  //   try {
  //     final response = await ApiClient.post(
  //       APIEndpointUrls.postTrip,
  //       data: data,
  //     );
  //     if (response.statusCode == 200) {
  //       debugPrint('postTrip: ${response.data}');
  //       return SuccessModel.fromJson(response.data);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error postTrip: $e');
  //     return null;
  //   }
  // }
  @override
  Future<SuccessModel?> postTrip(Map<String, dynamic> data) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(APIEndpointUrls.postTrip),
      );
      data.forEach((key, value) {
        if (key != 'image') {
          request.fields[key] = value.toString();
        }
      });

      if (data.containsKey('image') && data['image'] != null) {
        final imagePath = data['image'] as String;
        final imageFile = await http.MultipartFile.fromPath('image', imagePath);
        request.files.add(imageFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (streamedResponse.statusCode == 200) {
        debugPrint('postTrip: ${response.body}');
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return SuccessModel.fromJson(responseData);
      } else {
        debugPrint('postTrip failed with status: ${streamedResponse.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error postTrip: $e');
      return null;
    }
  }


  @override
  Future<Piechartexpencemodel?> Piechartdata() async {
    try {
      final response = await ApiClient.get(APIEndpointUrls.piechartdata);
      if (response.statusCode == 200) {
        debugPrint('chartExpense: ${response.data}');
        return Piechartexpencemodel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error chartExpense: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateExpensedata(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.put(
        "${APIEndpointUrls.putExpenseDetails}",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('Edit Expense data: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error EditExpense data: $e');
      return null;
    }
  }
}
