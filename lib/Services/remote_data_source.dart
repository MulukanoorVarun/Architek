import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Model/EditExpenceModel.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';
import 'package:tripfin/Model/PiechartExpenceModel.dart';
import 'package:tripfin/Model/UpdateExpenceModel.dart';
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

abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);
  Future<SuccessModel?> loginApi(Map<String, dynamic> data);
  Future<GetTripModel?> getTrip();
  Future<GetPrevousTripModel?> getPrevousTrip();
  Future<GetprofileModel?> getProfiledetails();
  Future<TripsSummaryResponse?> getTripcount();
  Future<Categoryresponsemodel?> getcategory();
  Future<ExpenseDetailModel?> getExpenseDetails();
  Future<GetCurrencyModel?> getCurrency();
  Future<SuccessModel?> postExpense(Map<String, dynamic> data);
  Future<Piechartexpencemodel?> Piechartdata();
  Future<Editexpencemodel?> EditExpensedata(Map<String, dynamic> data);
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
  Future<ExpenseDetailModel?> getExpenseDetails() async {
    try {
      Response res = await ApiClient.get("${APIEndpointUrls.getCategory}");
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
        APIEndpointUrls.editExpence,
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
  Future<Editexpencemodel?> EditExpensedata(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.put(
        APIEndpointUrls.editexpense,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('updateExpense: ${response.data}');
        return Editexpencemodel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error updateExpense: $e');
      return null;
    }
  }
}
