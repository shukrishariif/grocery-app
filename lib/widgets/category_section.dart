import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Fruits',
      'icon': Icons.apple,
      'color': Color(0xFFFFE0B2),
    },
    {
      'name': 'Vegetables',
      'icon': Icons.eco,
      'color': Color(0xFFE8F5E9),
    },
    {
      'name': 'Meat',
      'icon': Icons.restaurant,
      'color': Color(0xFFFFCDD2),
    },
    {
      'name': 'Dairy',
      'icon': Icons.egg,
      'color': Color(0xFFE1F5FE),
    },
    {
      'name': 'Bakery',
      'icon': Icons.breakfast_dining,
      'color': Color(0xFFFFF3E0),
    },
    {
      'name': 'Beverages',
      'icon': Icons.local_drink,
      'color': Color(0xFFE0F2F1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to categories page
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: categories[index]['color'],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        categories[index]['icon'],
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categories[index]['name'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
