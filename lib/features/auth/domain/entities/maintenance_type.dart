
class MaintenanceType {
  final String id;
  final String name;
  final String? description;
  final int? recommendedIntervalKm;
  final DateTime createdAt;

  const MaintenanceType({
    required this.id,
    required this.name,
    this.description,
    this.recommendedIntervalKm,
    required this.createdAt,
  });
}
