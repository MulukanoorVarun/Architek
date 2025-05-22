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
  dynamic? totalExpense;
  List<ExpenseData>? expenseData;

  Data({this.tripId, this.destination, this.totalExpense, this.expenseData});

  Data.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    destination = json['destination'];
    totalExpense = json['total_expense'];
    if (json['expense_data'] != null) {
      expenseData = <ExpenseData>[];
      json['expense_data'].forEach((v) {
        expenseData!.add(new ExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['destination'] = this.destination;
    data['total_expense'] = this.totalExpense;
    if (this.expenseData != null) {
      data['expense_data'] = this.expenseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseData {
  String? expenseId;
  String? categoryName;
  double? totalExpense; // Changed from dynamic? to double?
  double? percentage;
  String? date;
  String? remarks;
  String? colorCode;

  ExpenseData({
    this.expenseId,
    this.categoryName,
    this.totalExpense,
    this.percentage,
    this.date,
    this.remarks,
    this.colorCode,
  });

  ExpenseData.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'] as String?;
    categoryName = json['category_name'] as String?;
    totalExpense = (json['total_expense'] as num?)?.toDouble(); // Safe casting
    percentage = (json['percentage'] as num?)?.toDouble(); // Safe casting
    date = json['date'] as String?;
    remarks = json['remarks'] as String?; // Fixed key
    colorCode = json['color_code'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense_id'] = this.expenseId;
    data['category_name'] = this.categoryName;
    data['total_expense'] = this.totalExpense;
    data['percentage'] = this.percentage;
    data['date'] = this.date;
    data['remarks'] = this.remarks; // Fixed key
    data['color_code'] = this.colorCode;
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
