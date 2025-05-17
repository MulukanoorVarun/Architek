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
  double? totalExpense;
  List<Expense>? expenses;

  Data({this.totalExpense, this.expenses});

  Data.fromJson(Map<String, dynamic> json) {
    totalExpense = (json['total_expense'] as num?)?.toDouble();
    if (json['expenses'] != null) {
      expenses = <Expense>[];
      json['expenses'].forEach((v) {
        expenses!.add(Expense.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_expense'] = totalExpense;
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expense {
  String? expenseId;
  String? tripId;
  String? categoryName;
  double? expense;
  String? date;
  String? remarks;
  String? paymentMode;
  double? percentage;
  String? currency;

  Expense({
    this.expenseId,
    this.tripId,
    this.categoryName,
    this.expense,
    this.date,
    this.remarks,
    this.paymentMode,
    this.percentage,
    this.currency,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'];
    tripId = json['trip_id'];
    categoryName = json['category_name'];
    expense = (json['expense'] as num?)?.toDouble();
    date = json['date'];
    remarks = json['remarks'];
    paymentMode = json['payment_mode'];
    percentage = (json['percentage'] as num?)?.toDouble();
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expense_id'] = expenseId;
    data['trip_id'] = tripId;
    data['category_name'] = categoryName;
    data['expense'] = expense;
    data['date'] = date;
    data['remarks'] = remarks;
    data['payment_mode'] = paymentMode;
    data['percentage'] = percentage;
    data['currency'] = currency;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}