import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';

class ProductState {
  final List<ProductEntity> products;
  final List<String> categories;
  final List<ProductEntity> recentProducts;
  final bool isProductsLoading;
  final bool isCategoriesLoading;
  final String? error;
  final String? selectedCategory;

  const ProductState({
    this.products = const [],
    this.categories = const [],
    this.recentProducts = const [],
    this.isProductsLoading = false,
    this.isCategoriesLoading = false,
    this.error,
    this.selectedCategory,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    List<String>? categories,
    List<ProductEntity>? recentProducts,
    bool? isProductsLoading,
    bool? isCategoriesLoading,
    String? error,
    String? selectedCategory,
    bool clearError = false,
    bool clearSelectedCategory = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      recentProducts: recentProducts ?? this.recentProducts,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
    );
  }
}
