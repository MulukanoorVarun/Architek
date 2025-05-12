class GetTripModel {
  GetTripData? getTripData;
  Settings? settings;

  GetTripModel({this.getTripData, this.settings});

  GetTripModel.fromJson(Map<String, dynamic> json) {
    getTripData = json['data'] != null ? new GetTripData.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getTripData != null) {
      data['data'] = this.getTripData!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class GetTripData {
  String? id;
  String? destination;
  String? startDate;
  String? endDate;
  String? budget;

  GetTripData({this.id, this.destination, this.startDate, this.endDate, this.budget});

  GetTripData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    budget = json['budget'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['destination'] = this.destination;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['budget'] = this.budget;
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
