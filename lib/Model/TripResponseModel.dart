import 'LoginResponseModel.dart';

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