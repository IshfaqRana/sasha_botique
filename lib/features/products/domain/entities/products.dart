class Product {
  final String id;
  final String name;
  final double price;
  final List<String> imageUrl;
  final String category;
  final bool isWishlisted;
  final bool isPopular;
  final bool isBasics;
  final bool isOnSale;
  final double? salePrice;
  final String createdAt;
  final String gender;
  final List<String> colors;
  final List<String> sizes;
  final String productType;
  final String season;
  final String fitType;
  final String collection;
  final String brandName;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isWishlisted = false,
    this.isPopular = false,
    this.isOnSale = false,
    this.isBasics = false,
    this.salePrice,
    required this.createdAt,
    required this.gender,
    required this.colors,
    required this.sizes,
    required this.productType,
    required this.season,
    required this.fitType,
    required this.brandName,
    required this.collection,
    required this.description,
  });
}
