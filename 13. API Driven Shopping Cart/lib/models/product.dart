class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? 'Untitled Product').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: (json['category'] ?? 'General').toString(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }
}
