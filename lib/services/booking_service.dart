import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/service_request_model.dart';
import '../core/utils.dart';

class BookingService extends ChangeNotifier {
  final List<BookingModel> _bookings = [];
  final List<ServiceRequestModel> _serviceRequests = [];
  final List<QuotationModel> _quotations = [];
  bool _isLoading = false;

  List<BookingModel> get bookings {
    return List.from(_bookings)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<ServiceRequestModel> get serviceRequests {
    return List.from(_serviceRequests)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<QuotationModel> getQuotationsForRequest(String requestId) {
    return _quotations.where((q) => q.serviceRequestId == requestId).toList();
  }

  bool get isLoading => _isLoading;

  BookingService() {
    _loadMockData();
  }

  void _loadMockData() {
    final now = DateTime.now();

    _bookings.addAll([
      BookingModel(
        id: 'b1',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p1',
        professionalName: 'Ramesh Shrestha',
        serviceCategory: 'Plumbing',
        serviceDescription: 'Water heater repair and maintenance',
        location: 'Kathmandu, Nepal',
        scheduledDate: now.add(const Duration(days: 1)),
        scheduledTime: '10:00 AM',
        estimatedDuration: 2.0,
        price: 2000,
        status: 'confirmed',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      BookingModel(
        id: 'b2',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p2',
        professionalName: 'Sita Maharjan',
        serviceCategory: 'Electrical',
        serviceDescription: 'Complete house wiring for new room',
        location: 'Patan, Nepal',
        scheduledDate: now.add(const Duration(days: 3)),
        scheduledTime: '9:00 AM',
        estimatedDuration: 4.0,
        price: 4000,
        status: 'pending',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'b3',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        professionalId: 'p3',
        professionalName: 'Hari KC',
        serviceCategory: 'Carpentry',
        serviceDescription: 'Custom bookshelf design and installation',
        location: 'Bhaktapur, Nepal',
        scheduledDate: now.subtract(const Duration(days: 5)),
        scheduledTime: '11:00 AM',
        estimatedDuration: 3.0,
        price: 3500,
        status: 'completed',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ]);

    _serviceRequests.addAll([
      ServiceRequestModel(
        id: 'sr1',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        customerPhone: '9800000000',
        customerLocation: 'Kathmandu',
        category: 'Plumbing',
        title: 'Kitchen sink leaking',
        description:
            'The kitchen sink pipe is leaking water. Need urgent repair.',
        location: 'Kathmandu, Nepal',
        preferredDate: 'This week',
        budgetRange: '1000-3000',
        quotationCount: 3,
        status: 'quoted',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      ServiceRequestModel(
        id: 'sr2',
        customerId: 'c1',
        customerName: 'Anita Gurung',
        customerPhone: '9800000000',
        customerLocation: 'Lalitpur',
        category: 'Painting',
        title: 'Living room wall painting',
        description:
            'Need to repaint the living room walls. Approx 12x15 feet room.',
        location: 'Lalitpur, Nepal',
        preferredDate: 'Next week',
        budgetRange: '5000-10000',
        quotationCount: 0,
        status: 'open',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
    ]);

    _quotations.addAll([
      QuotationModel(
        id: 'q1',
        serviceRequestId: 'sr1',
        professionalId: 'p1',
        professionalName: 'Ramesh Shrestha',
        professionalPhotoUrl: null,
        price: 1500,
        description:
            'Will fix the sink pipe and check all connections. Includes 1 month warranty.',
        estimatedDuration: '1-2 hours',
        timeline: 'Can come tomorrow',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      QuotationModel(
        id: 'q2',
        serviceRequestId: 'sr1',
        professionalId: 'p6',
        professionalName: 'Gopal Tamang',
        professionalPhotoUrl: null,
        price: 2000,
        description:
            'Complete plumbing checkup and repair. Includes parts if needed.',
        estimatedDuration: '2-3 hours',
        timeline: 'Available today',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ]);

    notifyListeners();
  }

  Future<BookingModel?> createBooking({
    required String professionalId,
    required String professionalName,
    required String professionalPhotoUrl,
    required String serviceCategory,
    required String serviceDescription,
    required String location,
    required DateTime scheduledDate,
    required String scheduledTime,
    required double price,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final booking = BookingModel(
      id: AppUtils.generateId(),
      customerId: 'c1',
      customerName: 'Anita Gurung',
      professionalId: professionalId,
      professionalName: professionalName,
      professionalPhotoUrl: professionalPhotoUrl,
      serviceCategory: serviceCategory,
      serviceDescription: serviceDescription,
      location: location,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      price: price,
      status: 'pending',
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    _isLoading = false;
    notifyListeners();
    return booking;
  }

  Future<ServiceRequestModel?> createServiceRequest({
    required String category,
    required String title,
    required String description,
    String? location,
    String? preferredDate,
    String? budgetRange,
    List<String>? imageUrls,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final request = ServiceRequestModel(
      id: AppUtils.generateId(),
      customerId: 'c1',
      customerName: 'Anita Gurung',
      customerPhone: '9800000000',
      customerLocation: location,
      category: category,
      title: title,
      description: description,
      location: location,
      preferredDate: preferredDate,
      budgetRange: budgetRange,
      imageUrls: imageUrls,
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _serviceRequests.insert(0, request);
    _isLoading = false;
    notifyListeners();
    return request;
  }

  Future<void> acceptQuotation(String quotationId, String requestId) async {
    await Future.delayed(const Duration(seconds: 1));

    final index = _quotations.indexWhere((q) => q.id == quotationId);
    if (index != -1) {
      _quotations[index] = QuotationModel(
        id: _quotations[index].id,
        serviceRequestId: _quotations[index].serviceRequestId,
        professionalId: _quotations[index].professionalId,
        professionalName: _quotations[index].professionalName,
        professionalPhotoUrl: _quotations[index].professionalPhotoUrl,
        price: _quotations[index].price,
        description: _quotations[index].description,
        estimatedDuration: _quotations[index].estimatedDuration,
        timeline: _quotations[index].timeline,
        status: 'accepted',
        createdAt: _quotations[index].createdAt,
      );
    }

    // Update request status
    final reqIndex = _serviceRequests.indexWhere((r) => r.id == requestId);
    if (reqIndex != -1) {
      final quoted = _quotations[index];
      _serviceRequests[reqIndex] = _serviceRequests[reqIndex].copyWith(
        status: 'assigned',
        assignedProfessionalId: quoted.professionalId,
        assignedProfessionalName: quoted.professionalName,
      );
    }

    notifyListeners();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }

    notifyListeners();
  }

  BookingModel? getBookingById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  ServiceRequestModel? getServiceRequestById(String id) {
    try {
      return _serviceRequests.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
