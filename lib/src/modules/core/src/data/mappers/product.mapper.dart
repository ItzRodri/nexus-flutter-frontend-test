import 'package:nexustestapp/src/modules/core/src/data/dtos/product.dto.dart';
import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';

class ProductMapper {
  static ProductEntity toEntity(ProductDto dto) {
    return ProductEntity(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      category: dto.category,
      price: dto.price,
      discountPercentage: dto.discountPercentage,
      rating: dto.rating,
      stock: dto.stock,
      tags: dto.tags,
      brand: dto.brand,
      thumbnail: dto.thumbnail,
      images: dto.images,
      availabilityStatus: dto.availabilityStatus,
    );
  }
}
