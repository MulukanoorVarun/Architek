class Finishtripmodel {
  Data? data;
  Settings? settings;

  Finishtripmodel({this.data, this.settings});

  factory Finishtripmodel.fromJson(Map<String, dynamic> json) {
    return Finishtripmodel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'settings': settings?.toJson(),
    };
  }
}

class Data {
  String? tripId;
  String? destination;
  String? budget;
  String? totalExpense;
  String? status;

  Data({
    this.tripId,
    this.destination,
    this.budget,
    this.totalExpense,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      tripId: json['trip_id'],
      destination: json['destination'],
      budget: json['budget'],
      totalExpense: json['total_expense'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'destination': destination,
      'budget': budget,
      'total_expense': totalExpense,
      'status': status,
    };
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }
}
