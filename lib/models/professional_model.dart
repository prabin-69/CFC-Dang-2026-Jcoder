class ProfessionalModel {
  final String id;
  final String userId;
  final String name;
  final String? photoUrl;
  final String category;
  final List<String> subCategories;
  final String description;
  final String? experience;
  final double rating;
  final int reviewCount;
  final int jobCount;
  final double hourlyRate;
  final double? fixedRate;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String> skills;
  final List<String> certifications;
  final List<String> portfolioUrls;
  final bool isVerified;
  final bool isAvailable;
  final bool isOnline;
  final String? responseTime;
  final List<Review> recentReviews;
  final DateTime createdAt;

  ProfessionalModel({
    required this.id,
    required this.userId,
    required this.name,
    this.photoUrl,
    required this.category,
    this.subCategories = const [],
    required this.description,
    this.experience,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.jobCount = 0,
    this.hourlyRate = 0.0,
    this.fixedRate,
    this.location,
    this.latitude,
    this.longitude,
    this.skills = const [],
    this.certifications = const [],
    this.portfolioUrls = const [],
    this.isVerified = false,
    this.isAvailable = true,
    this.isOnline = false,
    this.responseTime,
    this.recentReviews = const [],
    required this.createdAt,
  });

  ProfessionalModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? photoUrl,
    String? category,
    List<String>? subCategories,
    String? description,
    String? experience,
    double? rating,
    int? reviewCount,
    int? jobCount,
    double? hourlyRate,
    double? fixedRate,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? skills,
    List<String>? certifications,
    List<String>? portfolioUrls,
    bool? isVerified,
    bool? isAvailable,
    bool? isOnline,
    String? responseTime,
    List<Review>? recentReviews,
    DateTime? createdAt,
  }) {
    return ProfessionalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      category: category ?? this.category,
      subCategories: subCategories ?? this.subCategories,
      description: description ?? this.description,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      jobCount: jobCount ?? this.jobCount,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      fixedRate: fixedRate ?? this.fixedRate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      responseTime: responseTime ?? this.responseTime,
      recentReviews: recentReviews ?? this.recentReviews,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'photoUrl': photoUrl,
      'category': category,
      'subCategories': subCategories,
      'description': description,
      'experience': experience,
      'rating': rating,
      'reviewCount': reviewCount,
      'jobCount': jobCount,
      'hourlyRate': hourlyRate,
      'fixedRate': fixedRate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'skills': skills,
      'certifications': certifications,
      'portfolioUrls': portfolioUrls,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'isOnline': isOnline,
      'responseTime': responseTime,
      'recentReviews': recentReviews.map((r) => r.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProfessionalModel.fromMap(Map<String, dynamic> map) {
    return ProfessionalModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      category: map['category'] ?? '',
      subCategories: List<String>.from(map['subCategories'] ?? []),
      description: map['description'] ?? '',
      experience: map['experience'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      jobCount: map['jobCount'] ?? 0,
      hourlyRate: (map['hourlyRate'] ?? 0.0).toDouble(),
      fixedRate: map['fixedRate']?.toDouble(),
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      skills: List<String>.from(map['skills'] ?? []),
      certifications: List<String>.from(map['certifications'] ?? []),
      portfolioUrls: List<String>.from(map['portfolioUrls'] ?? []),
      isVerified: map['isVerified'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
      isOnline: map['isOnline'] ?? false,
      responseTime: map['responseTime'],
      recentReviews:
          (map['recentReviews'] as List?)
              ?.map((r) => Review.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
