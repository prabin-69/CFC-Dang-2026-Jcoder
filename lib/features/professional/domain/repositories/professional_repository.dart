import '../entities/professional_entity.dart';

/// Abstract repository for professional discovery & management.
abstract class ProfessionalRepository {
  List<ProfessionalModel> get professionals;
  List<ProfessionalModel> get featuredProfessionals;
  bool get isLoading;
  String get searchQuery;
  String get selectedCategory;
  String get selectedSortBy;

  ProfessionalModel? getProfessionalById(String id);
  List<ProfessionalModel> getProfessionalsByCategory(String category);
  List<String> get categories;

  void setSearchQuery(String query);
  void setSelectedCategory(String category);
  void setSortBy(String sortBy);
}
