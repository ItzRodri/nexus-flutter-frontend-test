import 'package:dio/dio.dart';
import 'package:nexustestapp/src/modules/common/managers/api_constants.dart';
import 'package:nexustestapp/src/modules/core/src/data/dtos/product.dto.dart';
import 'package:nexustestapp/src/modules/core/src/data/mappers/product.mapper.dart';
import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository({required Dio dio}) : _dio = dio;

  Future<List<ProductEntity>> getProducts() async {
    final response = await _dio.get(urlProducts);
    final List<dynamic> data = response.data['products'];
    return data
        .map((item) => ProductMapper.toEntity(ProductDto.fromJson(item)))
        .toList();
  }

  Future<List<ProductEntity>> searchProducts(String query) async {
    final response = await _dio.get(
      urlProductSearch,
      queryParameters: {'q': query},
    );
    final List<dynamic> data = response.data['products'];
    return data
        .map((item) => ProductMapper.toEntity(ProductDto.fromJson(item)))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final response = await _dio.get(urlCategoryList);
    return List<String>.from(response.data);
  }

  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    final List<dynamic> data = response.data['products'];
    return data
        .map((item) => ProductMapper.toEntity(ProductDto.fromJson(item)))
        .toList();
  }

  Future<ProductEntity> getProductById(int id) async {
    final response = await _dio.get('/products/$id');
    return ProductMapper.toEntity(ProductDto.fromJson(response.data));
  }
}
