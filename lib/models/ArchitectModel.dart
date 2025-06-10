class ArchitectModel {
  bool? status;
  ArchitectData? data; // Renamed to ArchitectData

  ArchitectModel({this.status, this.data});

  ArchitectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ArchitectData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ArchitectData {
  int? currentPage;
  List<Architect>? data;  // The list of architects
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  ArchitectData(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ArchitectData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Architect>[];  // Create the list for architect data
      json['data'].forEach((v) {
        data!.add(Architect.fromJson(v));  // Map to Architect
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Architect {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? rememberToken;
  String? licenseNumber;
  String? specialization;
  int? yearsOfExperience;
  String? profilePicture;
  String? portfolioUrl;
  String? country;
  String? officeLocation;
  String? companyId;
  String? availableForNewProjects;
  String? createdAt;
  String? updatedAt;

  Architect(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.password,
        this.rememberToken,
        this.licenseNumber,
        this.specialization,
        this.yearsOfExperience,
        this.profilePicture,
        this.portfolioUrl,
        this.country,
        this.officeLocation,
        this.companyId,
        this.availableForNewProjects,
        this.createdAt,
        this.updatedAt});

  Architect.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    rememberToken = json['remember_token'];
    licenseNumber = json['license_number'];
    specialization = json['specialization'];
    yearsOfExperience = json['years_of_experience'];
    profilePicture = json['profile_picture'];
    portfolioUrl = json['portfolio_url'];
    country = json['country'];
    officeLocation = json['office_location'];
    companyId = json['company_id'];
    availableForNewProjects = json['available_for_new_projects'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['remember_token'] = this.rememberToken;
    data['license_number'] = this.licenseNumber;
    data['specialization'] = this.specialization;
    data['years_of_experience'] = this.yearsOfExperience;
    data['profile_picture'] = this.profilePicture;
    data['portfolio_url'] = this.portfolioUrl;
    data['country'] = this.country;
    data['office_location'] = this.officeLocation;
    data['company_id'] = this.companyId;
    data['available_for_new_projects'] = this.availableForNewProjects;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
