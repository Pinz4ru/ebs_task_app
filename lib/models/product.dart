class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String size;
  final String color;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.size,
    required this.color,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      imageUrl: json['main_image'] ?? '',
    );
  }
}
