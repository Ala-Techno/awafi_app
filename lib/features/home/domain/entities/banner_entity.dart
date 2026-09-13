class BannerEntity {
  final String id;
  final String imageUrl;
  final String title;
  final bool isActive;
  final int sortOrder;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.isActive,
    required this.sortOrder,
  });
}