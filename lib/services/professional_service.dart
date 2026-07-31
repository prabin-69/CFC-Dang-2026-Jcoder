import 'package:flutter/material.dart';
import '../models/professional_model.dart';

class ProfessionalService extends ChangeNotifier {
  final List<ProfessionalModel> _professionals = [];
  final List<ProfessionalModel> _featuredProfessionals = [];
  final bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedSortBy = 'rating';

  List<ProfessionalModel> get professionals {
    var filtered = List<ProfessionalModel>.from(_professionals);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.skills.any(
              (s) => s.toLowerCase().contains(_searchQuery.toLowerCase()),
            ) ||
            p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedCategory.isNotEmpty) {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    switch (_selectedSortBy) {
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.hourlyRate.compareTo(a.hourlyRate));
        break;
      case 'experience':
        filtered.sort((a, b) => (b.jobCount).compareTo(a.jobCount));
        break;
    }

    return filtered;
  }

  List<ProfessionalModel> get featuredProfessionals => _featuredProfessionals;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedSortBy => _selectedSortBy;

  ProfessionalService() {
    _loadMockProfessionals();
  }

  void _loadMockProfessionals() {
    final now = DateTime.now();

    _professionals.addAll([
      ProfessionalModel(
        id: 'p1',
        userId: 'u1',
        name: 'Ramesh Shrestha',
        photoUrl: null,
        category: 'Plumbing',
        subCategories: ['Pipe Repair', 'Water Heater', 'Drain Cleaning'],
        description:
            'Expert plumber with over 15 years of experience in residential and commercial plumbing. Specialized in pipe repair, water heater installation, and drain cleaning services.',
        experience: '15 years',
        rating: 4.8,
        reviewCount: 234,
        jobCount: 1200,
        hourlyRate: 800,
        fixedRate: 2000,
        location: 'Kathmandu, Nepal',
        latitude: 27.7172,
        longitude: 85.3240,
        skills: [
          'Pipe Repair',
          'Water Heater Installation',
          'Drain Cleaning',
          'Bathroom Fitting',
          'Tap Repair',
        ],
        certifications: ['Licensed Plumber - Nepal', 'Safety Certified'],
        portfolioUrls: [],
        isVerified: true,
        isAvailable: true,
        isOnline: true,
        responseTime: '< 30 min',
        recentReviews: [
          Review(
            id: 'r1',
            userId: 'c1',
            userName: 'Anita Gurung',
            rating: 5,
            comment: 'Excellent work! Fixed our water heater quickly.',
            createdAt: now.subtract(const Duration(days: 2)),
          ),
          Review(
            id: 'r2',
            userId: 'c2',
            userName: 'Binod Sharma',
            rating: 4,
            comment: 'Good service, on time.',
            createdAt: now.subtract(const Duration(days: 7)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 365)),
      ),
      ProfessionalModel(
        id: 'p2',
        userId: 'u2',
        name: 'Sita Maharjan',
        photoUrl: null,
        category: 'Electrical',
        subCategories: ['Wiring', 'Repair', 'Installation'],
        description:
            'Certified electrician with 10+ years of experience. Expert in house wiring, electrical repairs, and appliance installation.',
        experience: '10 years',
        rating: 4.9,
        reviewCount: 189,
        jobCount: 950,
        hourlyRate: 1000,
        fixedRate: 2500,
        location: 'Patan, Nepal',
        latitude: 27.6796,
        longitude: 85.3157,
        skills: [
          'House Wiring',
          'Electrical Repair',
          'Fan Installation',
          'Switch Board',
          'AC Installation',
        ],
        certifications: ['Master Electrician', 'NEA Certified'],
        portfolioUrls: [],
        isVerified: true,
        isAvailable: true,
        isOnline: false,
        responseTime: '< 1 hour',
        recentReviews: [
          Review(
            id: 'r3',
            userId: 'c3',
            userName: 'Kiran Rai',
            rating: 5,
            comment: 'Very professional and skilled.',
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 730)),
      ),
      ProfessionalModel(
        id: 'p3',
        userId: 'u3',
        name: 'Hari KC',
        photoUrl: null,
        category: 'Carpentry',
        subCategories: ['Furniture', 'Repair', 'Custom Design'],
        description:
            'Master carpenter specializing in custom furniture, kitchen cabinets, and home renovation.',
        experience: '20 years',
        rating: 4.7,
        reviewCount: 312,
        jobCount: 1500,
        hourlyRate: 900,
        location: 'Bhaktapur, Nepal',
        latitude: 27.6710,
        longitude: 85.4298,
        skills: [
          'Furniture Making',
          'Cabinet Installation',
          'Wood Repair',
          'Custom Design',
          'Restoration',
        ],
        certifications: ['Master Carpenter', 'Woodworking Expert'],
        portfolioUrls: [],
        isVerified: true,
        isAvailable: true,
        isOnline: true,
        responseTime: '< 15 min',
        recentReviews: [
          Review(
            id: 'r4',
            userId: 'c4',
            userName: 'Maya Tamang',
            rating: 5,
            comment: 'Beautiful furniture!',
            createdAt: now.subtract(const Duration(days: 5)),
          ),
          Review(
            id: 'r5',
            userId: 'c5',
            userName: 'Rajesh Hamal',
            rating: 4,
            comment: 'Good quality work.',
            createdAt: now.subtract(const Duration(days: 14)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 1095)),
      ),
      ProfessionalModel(
        id: 'p4',
        userId: 'u4',
        name: 'Deepa Sharma',
        photoUrl: null,
        category: 'Cleaning',
        subCategories: ['Home Cleaning', 'Office Cleaning', 'Deep Cleaning'],
        description:
            'Professional cleaning service provider. We make your space spotless with eco-friendly products.',
        experience: '8 years',
        rating: 4.6,
        reviewCount: 456,
        jobCount: 2000,
        hourlyRate: 500,
        fixedRate: 1500,
        location: 'Kathmandu, Nepal',
        latitude: 27.7000,
        longitude: 85.3340,
        skills: [
          'Home Cleaning',
          'Office Cleaning',
          'Deep Cleaning',
          'Carpet Cleaning',
          'Window Cleaning',
        ],
        certifications: ['Eco-Cleaning Certified', 'Health & Safety'],
        portfolioUrls: [],
        isVerified: true,
        isAvailable: true,
        isOnline: true,
        responseTime: '< 30 min',
        recentReviews: [
          Review(
            id: 'r6',
            userId: 'c6',
            userName: 'Sagar Thapa',
            rating: 5,
            comment: 'Very thorough cleaning!',
            createdAt: now.subtract(const Duration(days: 3)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 500)),
      ),
      ProfessionalModel(
        id: 'p5',
        userId: 'u5',
        name: 'Arun Bhandari',
        photoUrl: null,
        category: 'Painting',
        subCategories: ['Interior', 'Exterior', 'Texture'],
        description:
            'Professional painter with 12 years of experience. Specializing in interior and exterior painting.',
        experience: '12 years',
        rating: 4.5,
        reviewCount: 178,
        jobCount: 850,
        hourlyRate: 700,
        location: 'Lalitpur, Nepal',
        latitude: 27.6600,
        longitude: 85.3200,
        skills: [
          'Interior Painting',
          'Exterior Painting',
          'Texture Finish',
          'Waterproofing',
          'Color Consulting',
        ],
        certifications: ['Painting Contractor License'],
        portfolioUrls: [],
        isVerified: false,
        isAvailable: true,
        isOnline: false,
        responseTime: '< 2 hours',
        recentReviews: [
          Review(
            id: 'r7',
            userId: 'c7',
            userName: 'Pooja Adhikari',
            rating: 5,
            comment: 'Amazing color suggestions!',
            createdAt: now.subtract(const Duration(days: 10)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 400)),
      ),
      ProfessionalModel(
        id: 'p6',
        userId: 'u6',
        name: 'Gopal Tamang',
        photoUrl: null,
        category: 'Appliance Repair',
        subCategories: ['AC Repair', 'Washing Machine', 'Refrigerator'],
        description:
            'Expert in repairing all types of home appliances. Quick service with warranty.',
        experience: '14 years',
        rating: 4.8,
        reviewCount: 267,
        jobCount: 1300,
        hourlyRate: 850,
        fixedRate: 2200,
        location: 'Kathmandu, Nepal',
        latitude: 27.7100,
        longitude: 85.3400,
        skills: [
          'AC Repair',
          'Washing Machine Repair',
          'Refrigerator Service',
          'Microwave Repair',
          'Water Purifier',
        ],
        certifications: ['Appliance Repair Expert', 'Warranty Service Partner'],
        portfolioUrls: [],
        isVerified: true,
        isAvailable: true,
        isOnline: true,
        responseTime: '< 20 min',
        recentReviews: [
          Review(
            id: 'r8',
            userId: 'c8',
            userName: 'Sunita Lama',
            rating: 5,
            comment: 'Fixed my AC in no time!',
            createdAt: now.subtract(const Duration(days: 1)),
          ),
          Review(
            id: 'r9',
            userId: 'c9',
            userName: 'Prakash Neupane',
            rating: 5,
            comment: 'Very reasonable price.',
            createdAt: now.subtract(const Duration(days: 6)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 600)),
      ),
    ]);

    _featuredProfessionals.addAll([
      _professionals[0], // Ramesh - Plumbing
      _professionals[1], // Sita - Electrical
      _professionals[5], // Gopal - Appliance Repair
    ]);

    notifyListeners();
  }

  ProfessionalModel? getProfessionalById(String id) {
    try {
      return _professionals.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ProfessionalModel> getProfessionalsByCategory(String category) {
    return _professionals.where((p) => p.category == category).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _selectedSortBy = sortBy;
    notifyListeners();
  }

  List<String> get categories {
    final cats = <String>{};
    for (final p in _professionals) {
      cats.add(p.category);
    }
    return cats.toList()..sort();
  }
}
