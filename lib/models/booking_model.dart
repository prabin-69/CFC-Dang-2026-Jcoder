class BookingModel {
  final String id;
  final String customerId;
  final String customerName;
  final String? customerPhotoUrl;
  final String professionalId;
  final String professionalName;
  final String? professionalPhotoUrl;
  final String serviceCategory;
  final String serviceDescription;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime scheduledDate;
  final String? scheduledTime;
  final double? estimatedDuration;
  final double price;
  final String status; // pending, confirmed, in_progress, completed, cancelled
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerPhotoUrl,
    required this.professionalId,
    required this.professionalName,
    this.professionalPhotoUrl,
    required this.serviceCategory,
    required this.serviceDescription,
    this.location,
    this.latitude,
    this.longitude,
    required this.scheduledDate,
    this.scheduledTime,
    this.estimatedDuration,
    required this.price,
    this.status = 'pending',
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
  });

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhotoUrl,
    String? professionalId,
    String? professionalName,
    String? professionalPhotoUrl,
    String? serviceCategory,
    String? serviceDescription,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? scheduledDate,
    String? scheduledTime,
    double? estimatedDuration,
    double? price,
    String? status,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhotoUrl: customerPhotoUrl ?? this.customerPhotoUrl,
      professionalId: professionalId ?? this.professionalId,
      professionalName: professionalName ?? this.professionalName,
      professionalPhotoUrl: professionalPhotoUrl ?? this.professionalPhotoUrl,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      price: price ?? this.price,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
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
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalPhotoUrl': professionalPhotoUrl,
      'serviceCategory': serviceCategory,
      'serviceDescription': serviceDescription,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'estimatedDuration': estimatedDuration,
      'price': price,
      'status': status,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhotoUrl: map['customerPhotoUrl'],
      professionalId: map['professionalId'] ?? '',
      professionalName: map['professionalName'] ?? '',
      professionalPhotoUrl: map['professionalPhotoUrl'],
      serviceCategory: map['serviceCategory'] ?? '',
      serviceDescription: map['serviceDescription'] ?? '',
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      scheduledDate: DateTime.parse(
        map['scheduledDate'] ?? DateTime.now().toIso8601String(),
      ),
      scheduledTime: map['scheduledTime'],
      estimatedDuration: map['estimatedDuration']?.toDouble(),
      price: (map['price'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      cancellationReason: map['cancellationReason'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
