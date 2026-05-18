import 'package:flutter/material.dart';

const _orange = Color(0xFFFF6B00);
const _black = Color(0xFF1A1A1A);

const Map<String, String> _categoryEmojis = {
  'beauty': '💄',
  'fragrances': '🌸',
  'furniture': '🪑',
  'groceries': '🛒',
  'home-decoration': '🏠',
  'kitchen-accessories': '🍳',
  'laptops': '💻',
  'mens-shirts': '👔',
  'mens-shoes': '👞',
  'mens-watches': '⌚',
  'mobile-accessories': '🔌',
  'motorcycle': '🏍️',
  'skin-care': '🧴',
  'smartphones': '📱',
  'sports-accessories': '⚽',
  'sunglasses': '🕶️',
  'tablets': '📟',
  'tops': '👚',
  'vehicle': '🚗',
  'womens-bags': '👜',
  'womens-dresses': '👗',
  'womens-jewellery': '💍',
  'womens-shoes': '👠',
  'womens-watches': '⌚',
};

class CategoryChipWidget extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = _categoryEmojis[category] ?? '🏷️';
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _orange : _black,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? _orange
                : Colors.white.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _orange.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
