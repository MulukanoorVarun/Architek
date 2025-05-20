class ExpenseDetailModel {
  Data? data;
  Settings? settings;

  ExpenseDetailModel({this.data, this.settings});

  ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? expense;
  String? category;
  String? date;
  String? remarks;
  String? paymentMode;
  String? categoryName;
  String? trip;
  Null? billReceipt;

  Data(
      {this.id,
        this.expense,
        this.category,
        this.date,
        this.remarks,
        this.paymentMode,
        this.categoryName,
        this.trip,
        this.billReceipt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expense = json['expense'];
    category = json['category'];
    date = json['date'];
    remarks = json['remarks'];
    paymentMode = json['payment_mode'];
    categoryName = json['category_name'];
    trip = json['trip'];
    billReceipt = json['bill_receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expense'] = this.expense;
    data['category'] = this.category;
    data['date'] = this.date;
    data['remarks'] = this.remarks;
    data['payment_mode'] = this.paymentMode;
    data['category_name'] = this.categoryName;
    data['trip'] = this.trip;
    data['bill_receipt'] = this.billReceipt;
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
