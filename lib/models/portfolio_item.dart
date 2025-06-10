import 'package:equatable/equatable.dart';

class PortfolioItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final int year;
  final String? clientName;
  final String? location;
  final String category;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.year,
    this.clientName,
    this.location,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    images,
    year,
    clientName,
    location,
    category,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'year': year,
      'clientName': clientName,
      'location': location,
      'category': category,
    };
  }

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: List<String>.from(json['images']),
      year: json['year'],
      clientName: json['clientName'],
      location: json['location'],
      category: json['category'],
    );
  }
}