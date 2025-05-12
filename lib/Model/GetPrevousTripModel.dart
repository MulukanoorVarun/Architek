class GetPrevousTripModel {
  List<Data>? data;
  Settings? settings;

  GetPrevousTripModel({this.data, this.settings});

  GetPrevousTripModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? tripId;
  String? destination;
  String? startDate;
  String? endDate;
  int? budget;
  int? totalExpense;
  String? status;

  Data(
      {this.tripId,
        this.destination,
        this.startDate,
        this.endDate,
        this.budget,
        this.totalExpense,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    destination = json['destination'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    budget = json['budget'];
    totalExpense = json['total_expense'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['destination'] = this.destination;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['budget'] = this.budget;
    data['total_expense'] = this.totalExpense;
    data['status'] = this.status;
    return data;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  Settings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
