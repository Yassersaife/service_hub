// lib/features/service_provider/models/portfolio_image.dart

class PortfolioImage {
  final int id;
  final String imagePath;
  final String imageUrl;
  final DateTime? createdAt;

  const PortfolioImage({
    required this.id,
    required this.imagePath,
    required this.imageUrl,
    this.createdAt,
  });

  factory PortfolioImage.fromJson(Map<String, dynamic> json) {
    return PortfolioImage(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      imagePath: json['image_path']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'PortfolioImage(id: $id, imageUrl: $imageUrl)';
}