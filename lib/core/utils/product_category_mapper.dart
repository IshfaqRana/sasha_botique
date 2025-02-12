import 'package:sasha_botique/core/utils/product_category_enum.dart';

class CategoryMapper {
  static String getCategory(ProductCategory category) {
    switch (category) {
      case ProductCategory.popular:
        return "popular";
      case ProductCategory.newArrival:
        return "new-arrival";
      case ProductCategory.all:
        return "all";
      case ProductCategory.gender:
        return "gender";
      case ProductCategory.sale:
        return "sale";
    }
  }
}