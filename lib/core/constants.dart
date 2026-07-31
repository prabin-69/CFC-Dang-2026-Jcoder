class AppConstants {
  static const String appName = 'WorkLink';
  static const String tagline = 'Connect Skills. Solve Problems. Build Opportunities.';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefUserId = 'user_id';
  static const String prefGuestMode = 'guest_mode';
  static const String prefAuthToken = 'auth_token';

  // Firestore Collections
  static const String collectionUsers = 'users';
  static const String collectionProfessionals = 'professionals';
  static const String collectionBookings = 'bookings';
  static const String collectionServiceRequests = 'service_requests';
  static const String collectionQuotations = 'quotations';
  static const String collectionChats = 'chats';
  static const String collectionMessages = 'messages';
  static const String collectionNotifications = 'notifications';
  static const String collectionReviews = 'reviews';
  static const String collectionCategories = 'categories';

  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingInProgress = 'in_progress';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleProfessional = 'professional';
  static const String roleAdmin = 'admin';

  // Pagination
  static const int pageSize = 20;
}
