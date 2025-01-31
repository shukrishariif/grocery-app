class Category {
  final String id;
  final String name;
  final String imageUrl;
  final String backgroundColor;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
  });
}

final List<Category> categories = [
  Category(
    id: '1',
    name: 'Fresh Fruits\n& Vegetable',
    imageUrl: 'assets/images/categories/fruits_veg.png',
    backgroundColor: '#E6F2EA',
  ),
  Category(
    id: '2',
    name: 'Cooking Oil\n& Ghee',
    imageUrl: 'assets/images/categories/cooking_oil.png',
    backgroundColor: '#FFF6E3',
  ),
  Category(
    id: '3',
    name: 'Meat & Fish',
    imageUrl: 'assets/images/categories/meat.png',
    backgroundColor: '#FFE8E8',
  ),
  Category(
    id: '4',
    name: 'Bakery & Snacks',
    imageUrl: 'assets/images/categories/bakery.png',
    backgroundColor: '#F3EFFA',
  ),
  Category(
    id: '5',
    name: 'Dairy & Eggs',
    imageUrl: 'assets/images/categories/dairy.png',
    backgroundColor: '#FFF8E5',
  ),
  Category(
    id: '6',
    name: 'Beverages',
    imageUrl: 'assets/images/categories/beverages.png',
    backgroundColor: '#FFF3F3',
  ),
];
