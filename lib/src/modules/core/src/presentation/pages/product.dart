import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nexustestapp/src/modules/core/modular/navigation.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/bloc/product_cubit.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/bloc/product_state.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/widgets/category_chip_widget.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/widgets/product_card.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/widgets/product_skeleton.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/widgets/recent_products_carousel.dart';

const _orange = Color(0xFFFF6B00);
const _black = Color(0xFF1A1A1A);

class ProductHome extends StatefulWidget {
  const ProductHome({super.key});

  @override
  State<ProductHome> createState() => _ProductHomeState();
}

class _ProductHomeState extends State<ProductHome> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductCubit>(context).loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _showSearch = !_showSearch);
    if (!_showSearch) {
      _searchController.clear();
      BlocProvider.of<ProductCubit>(context).loadInitialData();
    }
  }

  void _onSearch() {
    BlocProvider.of<ProductCubit>(
      context,
    ).searchProducts(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: _black,
        elevation: 0,
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _onSearch(),
              )
            : Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Nexus Patio Tech',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
        actions: [
          if (_showSearch)
            IconButton(
              icon: const Icon(Icons.search, color: _orange),
              onPressed: _onSearch,
            ),
          IconButton(
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: _orange,
            ),
            onPressed: _toggleSearch,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Banner superior
              SliverToBoxAdapter(child: _buildBanner(state)),

              // Carrusel de vistos recientemente
              if (state.recentProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: RecentProductsCarousel(
                    products: state.recentProducts,
                    onTap: (product) => Modular.to.pushNamed(
                      ProductPath.productDetail,
                      arguments: product,
                    ),
                  ),
                ),

              // Categorías
              if (state.categories.isNotEmpty)
                SliverToBoxAdapter(child: _buildCategories(context, state)),

              // Header de la sección de productos
              SliverToBoxAdapter(child: _buildSectionHeader(state)),

              // Contenido principal
              if (state.isProductsLoading)
                const SliverFillRemaining(child: ProductSkeleton())
              else if (state.error != null)
                SliverFillRemaining(child: _buildError(context))
              else if (state.products.isEmpty)
                const SliverFillRemaining(child: _EmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Modular.to.pushNamed(
                          ProductPath.productDetail,
                          arguments: product,
                        ),
                      );
                    }, childCount: state.products.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBanner(ProductState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFFFF9A3C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Descubre lo mejor! 🔥',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.isProductsLoading
                      ? 'Cargando productos...'
                      : '${state.products.length} productos disponibles',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, ProductState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            return CategoryChipWidget(
              category: category,
              isSelected: state.selectedCategory == category,
              onTap: () => BlocProvider.of<ProductCubit>(
                context,
              ).filterByCategory(category),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ProductState state) {
    final label = state.selectedCategory != null
        ? state.selectedCategory!
        : _showSearch && _searchController.text.isNotEmpty
        ? 'Resultados: "${_searchController.text}"'
        : 'Todos los productos';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _black,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (!state.isProductsLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${state.products.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: Colors.red,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin conexión',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _black,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Verifica tu conexión a internet',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                BlocProvider.of<ProductCubit>(context).loadInitialData(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Reintentar',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
