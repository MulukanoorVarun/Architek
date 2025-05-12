class Login_ResponseModel {

late final Data data;
late final Settings settings;

Login_ResponseModel({required this.data, required this.settings});

factory Login_ResponseModel.fromJson(Map<String, dynamic> json) {
return Login_ResponseModel(
data: Data.fromJson(json['data']),
settings: Settings.fromJson(json['settings']),
);
}
}

class Data {
final String refresh;
final String access;
final int expiryTime;

Data({
required this.refresh,
required this.access,
required this.expiryTime,
});

factory Data.fromJson(Map<String, dynamic> json) {
return Data(
refresh: json['refresh'],
access: json['access'],
expiryTime: json['expiry_time'],
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