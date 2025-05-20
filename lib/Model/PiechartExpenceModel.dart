class Piechartexpencemodel {
  Data? data;
  Settings? settings;

  Piechartexpencemodel({this.data, this.settings});

  Piechartexpencemodel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  int? totalExpense;
  String? currency;
  List<CategoryData>? categoryData;

  Data(
      {this.tripId,
        this.destination,
        this.totalExpense,
        this.currency,
        this.categoryData});

  Data.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    destination = json['destination'];
    totalExpense = json['total_expense'];
    currency = json['currency'];
    if (json['category_data'] != null) {
      categoryData = <CategoryData>[];
      json['category_data'].forEach((v) {
        categoryData!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['destination'] = this.destination;
    data['total_expense'] = this.totalExpense;
    data['currency'] = this.currency;
    if (this.categoryData != null) {
      data['category_data'] =
          this.categoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String? categoryName;
  int? totalExpense;
  double? percentage;

  CategoryData({this.categoryName, this.totalExpense, this.percentage});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    totalExpense = json['total_expense'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['total_expense'] = this.totalExpense;
    data['percentage'] = this.percentage;
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
