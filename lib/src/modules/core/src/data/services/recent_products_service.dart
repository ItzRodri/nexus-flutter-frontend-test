import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexustestapp/src/modules/core/src/data/dtos/product.dto.dart';
import 'package:nexustestapp/src/modules/core/src/data/mappers/product.mapper.dart';
import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';

class RecentProductsService {
  static const _key = 'recent_products';
  static const _maxItems = 5;

  final SharedPreferences _prefs;

  RecentProductsService(this._prefs);

  Future<void> addProduct(ProductEntity product) async {
    final current = getProducts();
    // Elimina duplicado si ya existe
    current.removeWhere((p) => p.id == product.id);
    // Inserta al frente (más reciente primero)
    current.insert(0, product);
    // Recorta a máximo 5
    final trimmed = current.take(_maxItems).toList();
    final encoded =
        trimmed.map((p) => jsonEncode(_entityToJson(p))).toList();
    await _prefs.setStringList(_key, encoded);
  }

  List<ProductEntity> getProducts() {
    final raw = _prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => ProductMapper.toEntity(
            ProductDto.fromJson(jsonDecode(s) as Map<String, dynamic>)))
        .toList();
  }

  Map<String, dynamic> _entityToJson(ProductEntity e) => {
        'id': e.id,
        'title': e.title,
        'description': e.description,
        'category': e.category,
        'price': e.price,
        'discountPercentage': e.discountPercentage,
        'rating': e.rating,
        'stock': e.stock,
        'tags': e.tags,
        'brand': e.brand,
        'thumbnail': e.thumbnail,
        'images': e.images,
        'availabilityStatus': e.availabilityStatus,
      };
}
