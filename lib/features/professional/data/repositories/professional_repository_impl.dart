import '../../domain/entities/professional_entity.dart';
import '../../domain/repositories/professional_repository.dart';
import '../../../../services/professional_service.dart';

/// Mock implementation of [ProfessionalRepository] backed by existing ProfessionalService.
class ProfessionalRepositoryImpl implements ProfessionalRepository {
  final ProfessionalService _service;

  ProfessionalRepositoryImpl(this._service);

  @override
  List<ProfessionalModel> get professionals => _service.professionals;

  @override
  List<ProfessionalModel> get featuredProfessionals =>
      _service.featuredProfessionals;

  @override
  bool get isLoading => _service.isLoading;

  @override
  String get searchQuery => _service.searchQuery;

  @override
  String get selectedCategory => _service.selectedCategory;

  @override
  String get selectedSortBy => _service.selectedSortBy;

  @override
  ProfessionalModel? getProfessionalById(String id) =>
      _service.getProfessionalById(id);

  @override
  List<ProfessionalModel> getProfessionalsByCategory(String category) =>
      _service.getProfessionalsByCategory(category);

  @override
  List<String> get categories => _service.categories;

  @override
  void setSearchQuery(String query) => _service.setSearchQuery(query);

  @override
  void setSelectedCategory(String category) =>
      _service.setSelectedCategory(category);

  @override
  void setSortBy(String sortBy) => _service.setSortBy(sortBy);
}
