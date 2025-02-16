class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final bool isWishlisted;
  final bool isPopular;
  final bool isOnSale;
  final double? salePrice;
  final DateTime createdAt;
  final String gender;
  final List<String> colors;
  final List<String> sizes;
  final String productType;
  final String season;
  final String fitType;
  final String brand;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isWishlisted = false,
    this.isPopular = false,
    this.isOnSale = false,
    this.salePrice,
    required this.createdAt,
    required this.gender,
    required this.colors,
    required this.sizes,
    required this.productType,
    required this.season,
    required this.fitType,
    required this.brand,
  });
}
