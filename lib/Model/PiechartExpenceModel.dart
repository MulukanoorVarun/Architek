class Piechartexpencemodel {
  Data? data;
  Settings? settings;

  Piechartexpencemodel({this.data, this.settings});

  Piechartexpencemodel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  List<ExpenseData>? expenseData;

  Data({this.tripId, this.destination, this.totalExpense, this.expenseData});

  Data.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'] as String?;
    destination = json['destination'] as String?;
    // Handle double or int for totalExpense
    totalExpense = (json['total_expense'] is double)
        ? (json['total_expense'] as double).toInt()
        : json['total_expense'] as int?;
    if (json['expense_data'] != null) {
      expenseData = <ExpenseData>[];
      json['expense_data'].forEach((v) {
        expenseData!.add(ExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['destination'] = destination;
    data['total_expense'] = totalExpense;
    if (expenseData != null) {
      data['expense_data'] = expenseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseData {
  String? expenseId;
  String? categoryName;
  int? totalExpense;
  int? percentage;
  String? colorCode;
  String? date;

  ExpenseData({
    this.expenseId,
    this.categoryName,
    this.totalExpense,
    this.percentage,
    this.colorCode,
    this.date,
  });

  ExpenseData.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'] as String?;
    categoryName = json['category_name'] as String?;
    // Handle double or int for totalExpense
    totalExpense = (json['total_expense'] is double)
        ? (json['total_expense'] as double).toInt()
        : json['total_expense'] as int?;
    // Handle double or int for percentage
    percentage = (json['percentage'] is double)
        ? (json['percentage'] as double).toInt()
        : json['percentage'] as int?;
    colorCode = json['color_code'] as String?;
    date = json['date'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expense_id'] = expenseId;
    data['category_name'] = categoryName;
    data['total_expense'] = totalExpense;
    data['percentage'] = percentage;
    data['color_code'] = colorCode;
    data['date'] = date;
    return data;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  Settings.fromJson(Map<String, dynamic> json) {
    success = (json['success'] is double)
        ? (json['success'] as double).toInt()
        : json['success'] as int?;
    message = json['message'] as String?;
    status = (json['status'] is double)
        ? (json['status'] as double).toInt()
        : json['status'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}