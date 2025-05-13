class GetTripModel {
  GetTripData? getTripData;
  Settings? settings;

  GetTripModel({this.getTripData, this.settings});

  factory GetTripModel.fromJson(Map<String, dynamic> json) {
    return GetTripModel(
      getTripData: json['data'] != null ? GetTripData.fromJson(json['data']) : null,
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getTripData != null) {
      data['data'] = getTripData!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class GetTripData {
  String? id;
  String? destination;
  String? startDate;
  String? endDate;
  double? budget;

  GetTripData({
    this.id,
    this.destination,
    this.startDate,
    this.endDate,
    this.budget,
  });

  factory GetTripData.fromJson(Map<String, dynamic> json) {
    return GetTripData(
      id: json['id'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      budget: _parseBudget(json['budget']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['destination'] = destination;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['budget'] = budget;
    return data;
  }

  static double _parseBudget(dynamic budget) {
    if (budget == null) return 0.0;
    if (budget is num) return budget.toDouble();
    if (budget is String) {
      return double.tryParse(budget) ?? 0.0;
    }
    return 0.0;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: _parseInt(json['success']),
      message: json['message'] as String? ?? '',
      status: _parseInt(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}