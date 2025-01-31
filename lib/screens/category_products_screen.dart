import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  const CategoryProductsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  List<Product> getCategoryProducts() {
    if (category.name.contains('Beverages')) {
      return [
        Product(
          id: 'b1',
          name: 'orange',
          price: 1.99,
          imageUrl: 'image/orange.jpg',
          description: 'Sugar-fola beverage',
          category: 'Beverages',
          rating: 4.5,
          reviews: 150,
          calories: 0,
          quantity: '355ml, Price',
        ),
        Product(
          id: 'b2',
          name: 'Orange Juice',
          price: 1.50,
          imageUrl: 'image/orange.jpg',
          description: 'Lemon-lime flavored soft drink',
          category: 'Beverages',
          rating: 4.3,
          reviews: 120,
          calories: 140,
          quantity: '325ml, Price',
        ),
        Product(
          id: 'b3',
          name: 'Apple & Grape Juice',
          price: 15.99,
          imageUrl: 'image/orange.jpg',
          description: 'Natural fruit juice blend',
          category: 'Beverages',
          rating: 4.4,
          reviews: 180,
          calories: 120,
          quantity: '2L, Price',
        ),
        Product(
          id: 'b4',
          name: 'Coca Cola Can',
          price: 4.99,
          imageUrl: 'image/orange.jpg',
          description: 'Classic cola beverage',
          category: 'Beverages',
          rating: 4.7,
          reviews: 300,
          calories: 140,
          quantity: '325ml, Price',
        ),
        Product(
          id: 'b5',
          name: 'Pepsi Can',
          price: 4.99,
          imageUrl: 'assets/images/pepsi.png',
          description: 'Refreshing cola drink',
          category: 'Beverages',
          rating: 4.5,
          reviews: 250,
          calories: 150,
          quantity: '330ml, Price',
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final products = getCategoryProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.name.replaceAll('\n', ' '),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details screen (if needed)
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.quantity,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
