import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../services/booking_service.dart';

/// Mock implementation of [BookingRepository] backed by existing BookingService.
class BookingRepositoryImpl implements BookingRepository {
  final BookingService _service;

  BookingRepositoryImpl(this._service);

  @override
  List<BookingModel> get bookings => _service.bookings;

  @override
  List<ServiceRequestModel> get serviceRequests => _service.serviceRequests;

  @override
  bool get isLoading => _service.isLoading;

  @override
  List<QuotationModel> getQuotationsForRequest(String requestId) =>
      _service.getQuotationsForRequest(requestId);

  @override
  BookingModel? getBookingById(String id) => _service.getBookingById(id);

  @override
  ServiceRequestModel? getServiceRequestById(String id) =>
      _service.getServiceRequestById(id);

  @override
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
  }) => _service.createBooking(
    professionalId: professionalId,
    professionalName: professionalName,
    professionalPhotoUrl: professionalPhotoUrl,
    serviceCategory: serviceCategory,
    serviceDescription: serviceDescription,
    location: location,
    scheduledDate: scheduledDate,
    scheduledTime: scheduledTime,
    price: price,
    notes: notes,
  );

  @override
  Future<ServiceRequestModel?> createServiceRequest({
    required String category,
    required String title,
    required String description,
    String? location,
    String? preferredDate,
    String? budgetRange,
    List<String>? imageUrls,
  }) => _service.createServiceRequest(
    category: category,
    title: title,
    description: description,
    location: location,
    preferredDate: preferredDate,
    budgetRange: budgetRange,
    imageUrls: imageUrls,
  );

  @override
  Future<void> acceptQuotation(String quotationId, String requestId) =>
      _service.acceptQuotation(quotationId, requestId);

  @override
  Future<void> updateBookingStatus(String bookingId, String status) =>
      _service.updateBookingStatus(bookingId, status);
}
