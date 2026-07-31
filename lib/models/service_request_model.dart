class ServiceRequestModel {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerPhotoUrl;
  final String? customerPhone;
  final String? customerLocation;
  final String category;
  final String title;
  final String description;
  final List<String>? imageUrls;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? preferredDate;
  final String? budgetRange;
  final int quotationCount;
  final String status; // open, quoted, assigned, closed
  final String? assignedProfessionalId;
  final String? assignedProfessionalName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceRequestModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhotoUrl,
    this.customerPhone,
    this.customerLocation,
    required this.category,
    required this.title,
    required this.description,
    this.imageUrls,
    this.location,
    this.latitude,
    this.longitude,
    this.preferredDate,
    this.budgetRange,
    this.quotationCount = 0,
    this.status = 'open',
    this.assignedProfessionalId,
    this.assignedProfessionalName,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiceRequestModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhotoUrl,
    String? customerPhone,
    String? customerLocation,
    String? category,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? location,
    double? latitude,
    double? longitude,
    String? preferredDate,
    String? budgetRange,
    int? quotationCount,
    String? status,
    String? assignedProfessionalId,
    String? assignedProfessionalName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhotoUrl: customerPhotoUrl ?? this.customerPhotoUrl,
      customerPhone: customerPhone ?? this.customerPhone,
      customerLocation: customerLocation ?? this.customerLocation,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      preferredDate: preferredDate ?? this.preferredDate,
      budgetRange: budgetRange ?? this.budgetRange,
      quotationCount: quotationCount ?? this.quotationCount,
      status: status ?? this.status,
      assignedProfessionalId:
          assignedProfessionalId ?? this.assignedProfessionalId,
      assignedProfessionalName:
          assignedProfessionalName ?? this.assignedProfessionalName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhotoUrl': customerPhotoUrl,
      'customerPhone': customerPhone,
      'customerLocation': customerLocation,
      'category': category,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'preferredDate': preferredDate,
      'budgetRange': budgetRange,
      'quotationCount': quotationCount,
      'status': status,
      'assignedProfessionalId': assignedProfessionalId,
      'assignedProfessionalName': assignedProfessionalName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ServiceRequestModel.fromMap(Map<String, dynamic> map) {
    return ServiceRequestModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhotoUrl: map['customerPhotoUrl'],
      customerPhone: map['customerPhone'],
      customerLocation: map['customerLocation'],
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrls: map['imageUrls'] != null
          ? List<String>.from(map['imageUrls'])
          : null,
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      preferredDate: map['preferredDate'],
      budgetRange: map['budgetRange'],
      quotationCount: map['quotationCount'] ?? 0,
      status: map['status'] ?? 'open',
      assignedProfessionalId: map['assignedProfessionalId'],
      assignedProfessionalName: map['assignedProfessionalName'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class QuotationModel {
  final String id;
  final String serviceRequestId;
  final String professionalId;
  final String professionalName;
  final String? professionalPhotoUrl;
  final double price;
  final String? description;
  final String? estimatedDuration;
  final String? timeline;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;

  QuotationModel({
    required this.id,
    required this.serviceRequestId,
    required this.professionalId,
    required this.professionalName,
    this.professionalPhotoUrl,
    required this.price,
    this.description,
    this.estimatedDuration,
    this.timeline,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceRequestId': serviceRequestId,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalPhotoUrl': professionalPhotoUrl,
      'price': price,
      'description': description,
      'estimatedDuration': estimatedDuration,
      'timeline': timeline,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuotationModel.fromMap(Map<String, dynamic> map) {
    return QuotationModel(
      id: map['id'] ?? '',
      serviceRequestId: map['serviceRequestId'] ?? '',
      professionalId: map['professionalId'] ?? '',
      professionalName: map['professionalName'] ?? '',
      professionalPhotoUrl: map['professionalPhotoUrl'],
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'],
      estimatedDuration: map['estimatedDuration'],
      timeline: map['timeline'],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
