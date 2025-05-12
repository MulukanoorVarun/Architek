class SuccessModel {
  final dynamic data;  // Changed to dynamic
  final Settings? settings;

  SuccessModel({this.data, this.settings});

  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    return SuccessModel(
      // If data is a map, parse it into Data object. If it's an empty list or any other type, just store it as is.
      data: json['data'] != null
          ? (json['data'] is List ? json['data'] : Data.fromJson(json['data']))
          : null,
      settings: json['settings'] != null
          ? Settings.fromJson(json['settings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data is List ? data : (data as Data).toJson(),
      if (settings != null) 'settings': settings!.toJson(),
    };
  }
}

class Data {
  final String? id;

  Data({this.id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Settings {
  final int? success;
  final String? message;
  final int? status;

  Settings({this.success, this.message, this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'] as int?,
      message: json['message'] as String?,
      status: json['status'] as int?,
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
