class ProductDto {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final String availabilityStatus;

  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.thumbnail,
    required this.images,
    required this.availabilityStatus,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'] as String? ?? '',
      thumbnail: json['thumbnail'] as String,
      images: List<String>.from(json['images'] ?? []),
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
    );
  }
}
