class Tripresponsemodel {
  final Data data;
  final Settings settings;

  Tripresponsemodel({required this.data, required this.settings});

  factory Tripresponsemodel.fromJson(Map<String, dynamic> json) {
    return Tripresponsemodel(
      data: Data.fromJson(json['data']),
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class Data {
  final String id;
  final String destination;
  final String startDate;
  final String endDate;
  final String budget;

  Data({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      destination: json['destination'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      budget: json['budget'],
    );
  }
}

class Settings {
  final int success;
  final String message;
  final int status;

  Settings({
    required this.success,
    required this.message,
    required this.status,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'],
      message: json['message'],
      status: json['status'],
    );
  }
}
