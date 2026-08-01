/// Domain entity representing an authenticated user.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String role; // 'guest', 'customer', 'professional', 'business', 'admin'
  final String? bio;
  final String? location;
  final double rating;
  final int reviewCount;
  final List<String> skills;
  final bool isVerified;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    this.email = '',
    required this.phone,
    this.photoUrl,
    this.role = 'customer',
    this.bio,
    this.location,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.skills = const [],
    this.isVerified = false,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? role,
    String? bio,
    String? location,
    double? rating,
    int? reviewCount,
    List<String>? skills,
    bool? isVerified,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      skills: skills ?? this.skills,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
      'bio': bio,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'skills': skills,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      role: map['role'] ?? 'customer',
      bio: map['bio'],
      location: map['location'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      skills: List<String>.from(map['skills'] ?? []),
      isVerified: map['isVerified'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  bool get isProfessional => role == 'professional';
  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';
  bool get isBusiness => role == 'business';
}
