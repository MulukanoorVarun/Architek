import 'package:arkitek_app/models/architect.dart';

import '../models/portfolio_item.dart';
import '../models/testimonial.dart';

class ArchitectRepository {
  // Dummy data for architects
  final List<Architect> _architects = [
    Architect(
      id: '1',
      name: 'Sarah Johnson',
      profileImage: 'https://images.pexels.com/photos/3760263/pexels-photo-3760263.jpeg',
      specialization: ['Sustainable Design', 'Residential', 'Commercial', 'Urban Planning'],
      experience: 12,
      rating: 4.9,
      location: Location(
        city: 'San Francisco',
        state: 'CA',
        country: 'USA',
        coordinates: Coordinates(latitude: 37.7749, longitude: -122.4194),
      ),
      portfolio: [
        PortfolioItem(
          id: 'p1',
          title: 'Modern Eco Home',
          description: 'Sustainable residential project with solar integration',
          images: ['https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg'],
          year: 2022,
          category: 'Residential',
        ),
      ],
      about: 'Award-winning architectural firm specializing in sustainable residential and commercial designs. Our approach combines innovative solutions with environmental consciousness.',
      education: ['M.Arch, Harvard University', 'B.Arch, UC Berkeley'],
      certifications: ['LEED Certified', 'AIA Member'],
      testimonials: [
        Testimonial(
          id: 't1',
          clientName: 'Michael Chen',
          content: 'Sarah and her team designed our dream home with incredible attention to detail. The sustainable features have reduced our energy bills by 40%!',
          rating: 5.0,
          date: '2023-05-15',
        ),
      ],
      contactInfo: ContactInfo(
        email: 'sarah@modernspaces.com',
        phone: '+1 (415) 555-7890',
        website: 'www.modernspaces.com',
      ),
    ),
    Architect(
      id: '2',
      name: 'David Wilson',
      profileImage: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      specialization: ['Commercial', 'Modern Design'],
      experience: 15,
      rating: 4.7,
      location: Location(
        city: 'Chicago',
        state: 'IL',
        country: 'USA',
        coordinates: Coordinates(latitude: 41.8781, longitude: -87.6298),
      ),
      portfolio: [],
      about: 'Specializing in modern commercial architecture',
      education: ['M.Arch, Yale University'],
      certifications: ['AIA Member'],
      testimonials: [],
      contactInfo: ContactInfo(
        email: 'david@wilsonassociates.com',
        phone: '+1 (312) 555-1234',
      ),
    ),
    Architect(
      id: '3',
      name: 'Maya Patel',
      profileImage: 'https://images.pexels.com/photos/7245333/pexels-photo-7245333.jpeg',
      specialization: ['Residential', 'Interior Design'],
      experience: 8,
      rating: 4.8,
      location: Location(
        city: 'Seattle',
        state: 'WA',
        country: 'USA',
        coordinates: Coordinates(latitude: 47.6062, longitude: -122.3321),
      ),
      portfolio: [],
      about: 'Creating innovative residential spaces',
      education: ['B.Arch, University of Washington'],
      certifications: ['NCIDQ Certified'],
      testimonials: [],
      contactInfo: ContactInfo(
        email: 'maya@innovativedesign.com',
        phone: '+1 (206) 555-5678',
      ),
    ),
  ];

  Future<List<Architect>> getArchitects() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return _architects;
  }

  Future<List<Architect>> getFeaturedArchitects() async {
    await Future.delayed(const Duration(seconds: 1));
    // Return architects with highest ratings
    final featured = List<Architect>.from(_architects);
    featured.sort((a, b) => b.rating.compareTo(a.rating));
    return featured.take(3).toList();
  }

  Future<Architect> getArchitectById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _architects.firstWhere(
      (architect) => architect.id == id,
      orElse: () => throw Exception('Architect not found'),
    );
  }

  Future<List<Architect>> searchArchitects(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return _architects.where((architect) {
      final searchLower = query.toLowerCase();
      return architect.name.toLowerCase().contains(searchLower) ||
          architect.specialization.any((s) => s.toLowerCase().contains(searchLower)) ||
          architect.location.city.toLowerCase().contains(searchLower) ||
          architect.location.state.toLowerCase().contains(searchLower);
    }).toList();
  }

  Future<List<Architect>> filterArchitects({
    required List<String> specializations,
    required double minBudget,
    required double maxBudget,
    required int minExperience,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return _architects.where((architect) {
      if (minExperience > 0 && architect.experience < minExperience) {
        return false;
      }
      if (specializations.isNotEmpty &&
          !architect.specialization.any((s) => specializations.contains(s))) {
        return false;
      }
      return true;
    }).toList();
  }
}