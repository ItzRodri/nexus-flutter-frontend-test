import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexustestapp/src/modules/core/src/data/repositories/product.repository.dart';
import 'package:nexustestapp/src/modules/core/src/data/services/recent_products_service.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/bloc/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;
  final RecentProductsService _recentService;

  ProductCubit(this._repository, this._recentService)
      : super(const ProductState());

  Future<void> loadInitialData() async {
    final recent = _recentService.getProducts();
    emit(state.copyWith(
      isProductsLoading: true,
      isCategoriesLoading: true,
      recentProducts: recent,
      clearError: true,
    ));
    try {
      final products = await _repository.getProducts();
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        products: products,
        categories: categories,
        isProductsLoading: false,
        isCategoriesLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProductsLoading: false,
        isCategoriesLoading: false,
      ));
    }
  }

  void loadRecentProducts() {
    final recent = _recentService.getProducts();
    emit(state.copyWith(recentProducts: recent));
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      await loadInitialData();
      return;
    }
    emit(state.copyWith(
      isProductsLoading: true,
      clearSelectedCategory: true,
      clearError: true,
    ));
    try {
      final products = await _repository.searchProducts(query);
      emit(state.copyWith(products: products, isProductsLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isProductsLoading: false));
    }
  }

  Future<void> filterByCategory(String category) async {
    if (state.selectedCategory == category) {
      emit(state.copyWith(
          isProductsLoading: true, clearSelectedCategory: true));
      try {
        final products = await _repository.getProducts();
        emit(state.copyWith(products: products, isProductsLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isProductsLoading: false));
      }
      return;
    }
    emit(state.copyWith(
      isProductsLoading: true,
      selectedCategory: category,
      clearError: true,
    ));
    try {
      final products = await _repository.getProductsByCategory(category);
      emit(state.copyWith(products: products, isProductsLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isProductsLoading: false));
    }
  }
}
