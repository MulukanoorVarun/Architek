import 'package:equatable/equatable.dart';
import 'package:arkitek_app/models/portfolio_item.dart';
import 'package:arkitek_app/models/testimonial.dart';

class Architect extends Equatable {
  final String id;
  final String name;
  final String profileImage;
  final List<String> specialization;
  final int experience;
  final double rating;
  final Location location;
  final List<PortfolioItem> portfolio;
  final String about;
  final List<String> education;
  final List<String> certifications;
  final List<Testimonial> testimonials;
  final ContactInfo contactInfo;

  const Architect({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.location,
    required this.portfolio,
    required this.about,
    required this.education,
    required this.certifications,
    required this.testimonials,
    required this.contactInfo,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    specialization,
    experience,
    rating,
    location,
    portfolio,
    about,
    education,
    certifications,
    testimonials,
    contactInfo,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'specialization': specialization,
      'experience': experience,
      'rating': rating,
      'location': location.toJson(),
      'portfolio': portfolio.map((item) => item.toJson()).toList(),
      'about': about,
      'education': education,
      'certifications': certifications,
      'testimonials': testimonials.map((item) => item.toJson()).toList(),
      'contactInfo': contactInfo.toJson(),
    };
  }

  factory Architect.fromJson(Map<String, dynamic> json) {
    return Architect(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      specialization: List<String>.from(json['specialization']),
      experience: json['experience'],
      rating: json['rating'].toDouble(),
      location: Location.fromJson(json['location']),
      portfolio: (json['portfolio'] as List)
          .map((item) => PortfolioItem.fromJson(item))
          .toList(),
      about: json['about'],
      education: List<String>.from(json['education']),
      certifications: List<String>.from(json['certifications']),
      testimonials: (json['testimonials'] as List)
          .map((item) => Testimonial.fromJson(item))
          .toList(),
      contactInfo: ContactInfo.fromJson(json['contactInfo']),
    );
  }
}

class Location extends Equatable {
  final String city;
  final String state;
  final String country;
  final Coordinates coordinates;

  const Location({
    required this.city,
    required this.state,
    required this.country,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [city, state, country, coordinates];

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'coordinates': coordinates.toJson(),
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      state: json['state'],
      country: json['country'],
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }
}

class Coordinates extends Equatable {
  final double latitude;
  final double longitude;

  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class ContactInfo extends Equatable {
  final String email;
  final String phone;
  final String? website;

  const ContactInfo({
    required this.email,
    required this.phone,
    this.website,
  });

  @override
  List<Object?> get props => [email, phone, website];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}