/// [CategoryEntity] — Pure Domain representation of a product category.
class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

