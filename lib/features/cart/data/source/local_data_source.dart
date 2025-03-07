import '../models/cart_model.dart';

  String image1 =  "https://gracestore.pk/cdn/shop/files/WhatsAppImage2022-12-08at1.08.26AM.progressive_5000x_62269863-ef21-4bb1-8d28-c190f2f433b5_5000x.webp?v=1729686218";
  String image2 = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUoe7viRS6dE_QI-PK6P9hGMPmvh56XXEy_A&s';
  String image3 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Classic-Cotton-Salwar-Suit.jpg';
  String image4 =   'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/salwar.jpg';
  String image5 = 'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Churidar-Salwar-Suits.jpg';
  String image6 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Classic-Cotton-Salwar-Suit.jpg';
  String image7 =   'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Pakistani-Salwar-Suit.jpg';
  String image8 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Churidar-Salwar-Suits.jpg';
  String image9 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/salwar.jpg';
  String image10 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Classic-Cotton-Salwar-Suit.jpg';
  String image11 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Pant-Style-Salwar-Suits.jpg';
  String image12 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Lehariya-Salwar-Suits.jpg';
  String image13 =  'https://cdn.shopify.com/s/files/1/0681/3296/2546/files/Banarasi-Salwar-Suits.jpg';
 class CartLocalDataSource {

  final List<Map<String, dynamic>> _dummyData = [
  {
  'id': '1',
  'name': 'Pink Dress',
  'price': 40.00,
   'imageUrl': 'https://s3-alpha-sig.figma.com/img/2a36/6a01/f1d3a00c8c966c84506b654029d8dfc1?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=JdnxiKRbMKw7PxgGV15StsmxGxPo6JAJprYxaIQC-dGmqaLyzL-0I-~-Adae50gOP66gq0T-zrgRSHUGf4Dk2xG3-kBL46H0-sWyNY03AGSq58q~no-osT0WtPIzOtDv56rgdKhAh0b7ZYlucGAoxMr4~U8IiKUmqF7061uHtfBz6pXt5uoW8cz8UUkzJ78qSSdJkmBx0Qy~9kREv-N5LfpLg~lmOweeW0HcGAfrkq6Lesg-DD1L~DOkVS1489y3s8roIm1doAjeRIvObnTT4BOhyFFzzJqEb~LjYDY43j0IkCPLTnaX3LQ~kn-vBWWL38vZbvbh6MyrRDpnvjGFEg__',
  'category': 'men',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':true,
  },
  {
  'id': '2',
  'name': 'Printed Shirt',
  'price': 48.00,
  'imageUrl': 'https://s3-alpha-sig.figma.com/img/246c/cce8/89cab2ef94a788b71d4bfc81beec0ce3?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Y0d2l9C8MZrnA04koZTDgnLOabuIv21uqdLLb3of9Z1OwWpPqDRrgcLwEZQgM3ghr0HeEe~I1dRjen7GINKWS6lTCKctdtTmDPZXqEUILluXzyWaLnx1JkFGnlsBQQBYenjuKB3LiLVtTt5zrN9nzlEzvTqoYKNoGLtv7YYA2mPprGG29MJfeZirqzqvMxuOsZxckN0LVJXBVPxnwLdWssfdi80fcdw2igdP7NtK1SjqLl7vaBKcZN3wVqzvz9zxSIV351eUcLvJY12D-fQ2-Ep8AY6tJBoR0ev4h~dH9jMgMrlfO7yoWHu7-OaPoRqzZYaKg~gBB-BJBJHEsusH4Q__',
  'category': 'men',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':true,
  },
  {
  'id': '3',
  'name': 'Blazers',
  'price': 52.00,
  'imageUrl': 'https://s3-alpha-sig.figma.com/img/9eee/44bc/15ecaf19ce5bf6c9cdc5de10e404514f?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=VTEFAV1vmzuMpyC10eAXcIUwP9V8PB8JaJUreK3gSpJyAU4KhCLt0fsy9qfiK87102dCWjasNZAAZGIwzdcQThZ-4l82EqONbcawjYE~RElqX5pDp-HRkhq9EWTHL0loIzQwB3OQJoNwbb3K1W2EYb6whOYMxzBrCPmVPPruPr1acbaIKXmGxPiB5W1eAktIzD~ljnjKx3WevfFgqj~g3O1H2d03XdZUR5SmX6MrwLb6u3yyrWPpMfSfBkPTHyFUt0mkpM5zjiAmyEz5935yCOKCXlJtx5rJu2bDyVfsIyVPX1APUdtpGeMD5Zffp8TjDpTf-tbL~GQMbMKGOnU5Bg__',
  'category': 'men',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':true,
  },
  {
  'id': '4',
  'name': 'Plain Shirt',
  'price': 56.00,
  'imageUrl': 'https://s3-alpha-sig.figma.com/img/9ee5/d7da/6899d2a391133ba4f93124bb69ef58aa?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Dt313V6Y6Lq8FpcXk8vFTkHUs8UHDTsjjK1GbZ1nzmG3VCqi2vxj2VV7FRew8ophcmIpSI1EG1tdUOkElT4YJZJOXANdKJxl6QYllQTr0nPt4sJaaVc-FWcKxZtvSr~EijNANmP2isOn1S8vAno9-z9Kun76esV2ezElMSyv~EiVpV~wXyTTPbaoJJGjxwk8nDjSknpa0V5sLUir0KZGAE8bAq~eqzQ6Drh-Gu-1Y7IahHP2J-AkcgAOUIVk1YVDG7a6zbwlItx8LOeCAR1EpH80KZDKBTy16KXo6LGadDYdYuWl2qD6yjjTwyrTFwGMpI~bfxqVy8CTp7V1uKWZYw__',
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':false,
  },
  {
  'id': '5',
  'name': 'Pink Dress',
  'price': 60.00,
  'imageUrl': 'https://www.affordable.pk/uploads/products/thumbs/large_16847686990_Bottle_Green_Gotta_3pc_Ready_to_Wear_Suit_For_Women_11zon.jpg',
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':false,
  },{
  'id': '6',
  'name': 'Pink Dress6',
  'price': 60.00,
  'imageUrl': image1,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'men',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':true,
  },{
  'id': '7',
  'name': 'Pink Dress7',
  'price': 10.00,
  'imageUrl': image2,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'men',
  'colors': ['Pink', 'Red','Black'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },{
  'id': '8',
  'name': 'Pink Dress8',
  'price': 20.00,
  'imageUrl': image3,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
      'isCarted':false,
  'fitType': 'Regular',
  },{
  'id': '9',
  'name': 'Pink Dress9',
  'price': 80.00,
  'imageUrl': image4,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': true,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },{
  'id': '10',
  'name': 'Pink Dress',
  'price': 40.00,
  'imageUrl': image5,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':true,
  },{
  'id': '10',
  'name': 'Pink Dress10',
  'price': 60.00,
  'imageUrl': image6,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':true,
  },{
  'id': '11',
  'name': 'Pink Dress11',
  'price': 45.00,
  'imageUrl': image7,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },{
  'id': '12',
  'name': 'Pink Dress12',
  'price': 49.00,
  'imageUrl': image8,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },{
  'id': '13',
  'name': 'Pink Dress13',
  'price': 50.00,
  'imageUrl': image13,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': false,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':true,
  },{
  'id': '14',
  'name': 'Pink Dress14',
  'price': 120.00,
  'imageUrl': image12,
  'category': 'Women',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'men',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },{
  'id': '15',
  'name': 'Pink Dress15',
  'price': 22.00,
  'imageUrl': image11,
  'category': 'men',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
      'isCarted':false,
  },
  {
  'id': '16',
  'name': 'Pink Dress16',
  'price': 32.00,
  'imageUrl': image10,
  'category': 'men',
  'isWishlisted': false,
  'isPopular': true,
  'isOnSale': false,
  'createdAt': '2024-02-12T00:00:00Z',
  'gender': 'women',
  'colors': ['Pink', 'Red'],
  'sizes': ['S', 'M', 'L'],
  'productType': 'Dress',
  'season': 'Summer',
  'fitType': 'Regular',
    'isCarted':true,
  },
  ];


  Future<List<CartItemModel>> getCartItems() async {
    List<Map<String, dynamic>> filteredData = _dummyData
        .where((product) => product['isCarted'])
        .toList();

    return filteredData.map((item)=> CartItemModel.fromJson(item)).toList();
  }
}