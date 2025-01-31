import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;

  // All products list
  final List<Product> _allProducts = [
    Product(
      id: 'b1',
      name: 'Diet Coke',
      price: 1.99,
      imageUrl: 'assets/images/products/diet_coke.png',
      description: 'Sugar-free cola beverage',
      category: 'Beverages',
      rating: 4.5,
      reviews: 150,
      calories: 0,
      quantity: '355ml, Price',
    ),
    Product(
      id: 'b2',
      name: 'Sprite Can',
      price: 1.50,
      imageUrl: 'assets/images/products/sprite.png',
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
      imageUrl: 'assets/images/products/apple_grape_juice.png',
      description: 'Natural fruit juice blend',
      category: 'Beverages',
      rating: 4.4,
      reviews: 180,
      calories: 120,
      quantity: '2L, Price',
    ),
    Product(
      id: 'b4',
      name: 'Orange Juice',
      price: 15.99,
      imageUrl: 'assets/images/products/orange_juice.png',
      description: '100% pure orange juice',
      category: 'Beverages',
      rating: 4.6,
      reviews: 200,
      calories: 110,
      quantity: '2L, Price',
    ),
    Product(
      id: 'b5',
      name: 'Coca Cola Can',
      price: 4.99,
      imageUrl: 'assets/images/products/coca_cola.png',
      description: 'Classic cola beverage',
      category: 'Beverages',
      rating: 4.7,
      reviews: 300,
      calories: 140,
      quantity: '325ml, Price',
    ),
    Product(
      id: 'b6',
      name: 'Pepsi Can',
      price: 4.99,
      imageUrl: 'assets/images/products/pepsi.png',
      description: 'Refreshing cola drink',
      category: 'Beverages',
      rating: 4.5,
      reviews: 250,
      calories: 150,
      quantity: '330ml, Price',
    ),
    Product(
      id: 'e1',
      name: 'Egg Chicken Red',
      price: 1.99,
      imageUrl: 'assets/images/products/egg_red.png',
      description: 'Fresh farm eggs',
      category: 'Dairy & Eggs',
      rating: 4.5,
      reviews: 150,
      calories: 70,
      quantity: '4pcs, Price',
    ),
    Product(
      id: 'e2',
      name: 'Egg Chicken White',
      price: 1.50,
      imageUrl: 'assets/images/products/egg_white.png',
      description: 'Fresh white eggs',
      category: 'Dairy & Eggs',
      rating: 4.3,
      reviews: 120,
      calories: 70,
      quantity: '180g, Price',
    ),
    Product(
      id: 'e3',
      name: 'Egg Pasta',
      price: 15.99,
      imageUrl: 'assets/images/products/egg_pasta.png',
      description: 'Fresh egg pasta',
      category: 'Pasta',
      rating: 4.4,
      reviews: 180,
      calories: 350,
      quantity: '30gm, Price',
    ),
    Product(
      id: 'e4',
      name: 'Egg Noodles',
      price: 15.99,
      imageUrl: 'assets/images/products/egg_noodles.png',
      description: 'Fresh egg noodles',
      category: 'Noodles',
      rating: 4.6,
      reviews: 200,
      calories: 320,
      quantity: '2L, Price',
    ),
    Product(
      id: 'e5',
      name: 'Mayonnais Eggless',
      price: 4.99,
      imageUrl: 'assets/images/products/mayo_eggless.png',
      description: 'Eggless mayonnaise',
      category: 'Condiments',
      rating: 4.2,
      reviews: 90,
      calories: 100,
      quantity: '500ml, Price',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Show all products initially
    _searchResults = _allProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) {
      setState(() {
        _searchResults = _allProducts;
        _isLoading = false;
      });
      return;
    }

    final results = _allProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {
                      // Implement filter functionality
                    },
                  ),
                ],
              ),
            ),
            onChanged: _performSearch,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Start searching for products'
                            : 'No products found',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return _buildProductCard(context, product);
                  },
                ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
        ],
      ),
    );
  }
}
