import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> requirements;
  final Budget budget;
  final String location;
  final Timeline timeline;
  final List<String>? attachments;
  final String status;
  final String clientId;
  final String? architectId;
  final String createdAt;
  final String updatedAt;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.requirements,
    required this.budget,
    required this.location,
    required this.timeline,
    this.attachments,
    required this.status,
    required this.clientId,
    this.architectId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    requirements,
    budget,
    location,
    timeline,
    attachments,
    status,
    clientId,
    architectId,
    createdAt,
    updatedAt,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requirements': requirements,
      'budget': budget.toJson(),
      'location': location,
      'timeline': timeline.toJson(),
      'attachments': attachments,
      'status': status,
      'clientId': clientId,
      'architectId': architectId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      requirements: List<String>.from(json['requirements']),
      budget: Budget.fromJson(json['budget']),
      location: json['location'],
      timeline: Timeline.fromJson(json['timeline']),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      status: json['status'],
      clientId: json['clientId'],
      architectId: json['architectId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Budget extends Equatable {
  final double min;
  final double max;
  final String currency;

  const Budget({
    required this.min,
    required this.max,
    required this.currency,
  });

  @override
  List<Object?> get props => [min, max, currency];

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'currency': currency,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      currency: json['currency'],
    );
  }
}

class Timeline extends Equatable {
  final String startDate;
  final String? endDate;
  final int? duration;

  const Timeline({
    required this.startDate,
    this.endDate,
    this.duration,
  });

  @override
  List<Object?> get props => [startDate, endDate, duration];

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
    };
  }

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      startDate: json['startDate'],
      endDate: json['endDate'],
      duration: json['duration'],
    );
  }
}