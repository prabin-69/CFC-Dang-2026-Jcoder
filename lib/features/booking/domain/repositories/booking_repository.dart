import '../entities/booking_entity.dart';

/// Abstract repository for bookings, service requests & quotations.
abstract class BookingRepository {
  List<BookingModel> get bookings;
  List<ServiceRequestModel> get serviceRequests;
  bool get isLoading;

  List<QuotationModel> getQuotationsForRequest(String requestId);
  BookingModel? getBookingById(String id);
  ServiceRequestModel? getServiceRequestById(String id);

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
  });

  Future<ServiceRequestModel?> createServiceRequest({
    required String category,
    required String title,
    required String description,
    String? location,
    String? preferredDate,
    String? budgetRange,
    List<String>? imageUrls,
  });

  Future<void> acceptQuotation(String quotationId, String requestId);
  Future<void> updateBookingStatus(String bookingId, String status);
}
