import 'package:flutter/material.dart';
import 'package:nexustestapp/src/modules/core/src/domain/product.entity.dart';

const _orange = Color(0xFFFF6B00);
const _black = Color(0xFF1A1A1A);

class RecentProductsCarousel extends StatefulWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onTap;

  const RecentProductsCarousel({
    super.key,
    required this.products,
    required this.onTap,
  });

  @override
  State<RecentProductsCarousel> createState() => _RecentProductsCarouselState();
}

class _RecentProductsCarouselState extends State<RecentProductsCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
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
                const Text(
                  'Vistos recientemente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _black,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: _orange,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          // PageView de productos
          SizedBox(
            height: 148,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.products.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => widget.onTap(widget.products[index]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _CarouselCard(product: widget.products[index]),
                ),
              ),
            ),
          ),

          // Dots indicadores
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.products.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == i ? _orange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final ProductEntity product;

  const _CarouselCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            // Imagen izquierda
            SizedBox(
              width: 120,
              height: double.infinity,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // Detalle derecha
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge categoría
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _orange.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: _orange,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 7),

                    // Título
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _black,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),

                    // Precio
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _orange,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
