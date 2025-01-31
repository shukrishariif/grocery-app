import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy products data - In a real app, this would come from an API
    final products = [
      {
        'id': '1',
        'name': 'Fresh Apple',
        'price': 3.99,
        'image': 'image/apple.png',
        'description': 'Fresh and juicy apples from local farms',
      },
      {
        'id': '2',
        'name': 'Banana',
        'price': 2.49,
        'image': 'image/banana.png',
        'description': 'Ripe and sweet bananas',
      },
      {
        'id': '2',
        'name': 'Banana',
        'price': 2.49,
        'image': 'image/banana.png',
        'description': 'Ripe and sweet bananas',
      },
      {
        'id': '3',
        'name': 'kootSto',
        'price': 2.49,
        'image': 'image/WhatsApp Image 2025-01-28 at 17.24.12_4465657e.jpg',
        'description': 'Ripe and sweet bananas',
      },

      // Add more products...
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                id: product['id'] as String,
                name: product['name'] as String,
                price: product['price'] as double,
                image: product['image'] as String,
                description: product['description'] as String,
                product: null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  const ProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product-details',
        arguments: {
          'id': id,
          'name': name,
          'price': price,
          'image': image,
          'description': description,
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesProvider>(
                    builder: (context, favorites, _) {
                      final isFavorite = favorites.isFavorite(id);
                      return GestureDetector(
                        onTap: () {
                          // Toggle favorite
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final isInCart = cart.items.containsKey(id);
                      return SizedBox(
                        width: double.infinity,
                        child: isInCart
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: AppTheme.primaryColor,
                                    ),
                                    onPressed: () {
                                      cart.decrementItem(id);
                                    },
                                  ),
                                  Text(
                                    '${cart.items[id]!.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: AppTheme.primaryColor,
                                    ),
                                    onPressed: () {
                                      cart.addItem(id, name, price, image);
                                    },
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  cart.addItem(id, name, price, image);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text('Add to Cart'),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
