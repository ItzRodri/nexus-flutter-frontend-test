import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nexustestapp/src/modules/core/src/data/services/recent_products_service.dart';
import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';
import 'package:nexustestapp/src/modules/core/src/presentation/bloc/product_cubit.dart';

const _orange = Color(0xFFFF6B00);
const _black = Color(0xFF1A1A1A);

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImage = 0;
  late final ProductEntity product;

  @override
  void initState() {
    super.initState();
    product = Modular.args.data as ProductEntity;
    Modular.get<RecentProductsService>().addProduct(product).then((_) {
      Modular.get<ProductCubit>().loadRecentProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Imagen con AppBar transparente
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: _black,
                iconTheme:
                    const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImage = i),
                        itemBuilder: (context, index) => Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: const Color(0xFF2A2A2A),
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 64),
                          ),
                        ),
                      ),
                      // Gradient inferior para el indicador
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xCC000000),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Indicadores de imagen
                      if (images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: List.generate(
                              images.length,
                              (i) => AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 3),
                                width: _currentImage == i ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImage == i
                                      ? _orange
                                      : Colors.white.withValues(
                                          alpha: 0.5),
                                  borderRadius:
                                      BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Contenido del detalle
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badges: categoría + disponibilidad
                            Row(
                              children: [
                                _Badge(
                                  label: product.category,
                                  color: _orange.withValues(alpha: 0.12),
                                  textColor: _orange,
                                  borderColor: _orange,
                                ),
                                const SizedBox(width: 8),
                                _Badge(
                                  label: product.availabilityStatus,
                                  color: product.availabilityStatus ==
                                          'In Stock'
                                      ? Colors.green.shade50
                                      : Colors.orange.shade50,
                                  textColor: product.availabilityStatus ==
                                          'In Stock'
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  borderColor: product.availabilityStatus ==
                                          'In Stock'
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Título
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _black,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.brand,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),

                            // Precio + descuento
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: _orange,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '-${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Stats row
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _StatItem(
                                    icon: Icons.star_rounded,
                                    iconColor: Colors.amber,
                                    label: 'Rating',
                                    value: product.rating
                                        .toStringAsFixed(1),
                                  ),
                                  _buildDivider(),
                                  _StatItem(
                                    icon: Icons.inventory_2_outlined,
                                    iconColor: _orange,
                                    label: 'Stock',
                                    value: '${product.stock}',
                                  ),
                                  _buildDivider(),
                                  _StatItem(
                                    icon: Icons.local_shipping_outlined,
                                    iconColor: Colors.blue,
                                    label: 'SKU',
                                    value: product.category
                                        .split('-')
                                        .first
                                        .toUpperCase(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Descripción
                            const Text(
                              'Descripción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description,
                              style: const TextStyle(
                                color: Color(0xFF555555),
                                height: 1.65,
                                fontSize: 14,
                              ),
                            ),

                            // Tags
                            if (product.tags.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              const Text(
                                'Tags',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: product.tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _black,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '# $tag',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                            // Espacio para el botón flotante
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botón CTA flotante
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade300, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.favorite_border,
                        color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: 20),
                        label: const Text(
                          'Agregar al carrito',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color borderColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
