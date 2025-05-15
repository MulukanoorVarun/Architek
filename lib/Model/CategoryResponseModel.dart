class Categoryresponsemodel {
  List<CategoryModel>? data;
  Settings? settings;

  Categoryresponsemodel({this.data, this.settings});

  factory Categoryresponsemodel.fromJson(Map<String, dynamic> json) {
    return Categoryresponsemodel(
      data: json['data'] != null
          ? List<CategoryModel>.from(
          json['data'].map((x) => CategoryModel.fromJson(x)))
          : null,
      settings: json['settings'] != null
          ? Settings.fromJson(json['settings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((x) => x.toJson()).toList(),
      'settings': settings?.toJson(),
    };
  }
}

class CategoryModel {
  String? id;
  String? categoryName;
  bool? isDefault;

  CategoryModel({this.id, this.categoryName, this.isDefault});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['category_name'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'is_default': isDefault,
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
