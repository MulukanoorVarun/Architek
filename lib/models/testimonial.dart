import 'package:equatable/equatable.dart';

class Testimonial extends Equatable {
  final String id;
  final String clientName;
  final String? clientImage;
  final String content;
  final double rating;
  final String date;
  final String? projectId;

  const Testimonial({
    required this.id,
    required this.clientName,
    this.clientImage,
    required this.content,
    required this.rating,
    required this.date,
    this.projectId,
  });

  @override
  List<Object?> get props => [
    id,
    clientName,
    clientImage,
    content,
    rating,
    date,
    projectId,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientImage': clientImage,
      'content': content,
      'rating': rating,
      'date': date,
      'projectId': projectId,
    };
  }

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'],
      clientName: json['clientName'],
      clientImage: json['clientImage'],
      content: json['content'],
      rating: json['rating'].toDouble(),
      date: json['date'],
      projectId: json['projectId'],
    );
  }
}