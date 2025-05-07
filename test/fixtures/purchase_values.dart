import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/data/models/product/purchase_products_model.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/src/domain/entities/product/purchase_products_entity.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/year_and_month_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<PurchaseProductsEntity> purchaseEntities = [
  PurchaseProductsEntity(
    purchaseId: '23434',
    price: '2000.00',
    dateCreated: Timestamp.now(),
    products: ['product_003', 'product_001'],
  ),
];

final List<PurchaseProductsModel> purchaseModels = [
  PurchaseProductsModel(
    purchaseId: '23434',
    price: '2000.00',
    dateCreated: Timestamp.now(),
    products: ['product_003', 'product_001'],
  ),
];

const List<String> purchasedProductIdList = [
  'product_003',
  'product_002',
];

const List<ProductEntity> purchasedProductEntities = [
  ProductEntity(
    id: 'product_002',
    productName: 'Product Two',
    price: '199.99',
    category: 'Ui Kits',
    marketingType: 'Latest',
    description: 'Product Two description',
    coverImage: 'https://example.com/images/cover/x_2.jpg',
    subImages: [
      'https://example.com/images/sub/x_3.jpg',
      'https://example.com/images/sub/x_4.jpg',
    ],
    zipFile: 'https://example.com/files/x_2.zip',
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
  ProductEntity(
    id: 'product_003',
    productName: 'Product Three',
    price: '1499.99',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Three description',
    coverImage: 'https://example.com/images/cover/x_3.jpg',
    subImages: [
      'https://example.com/images/sub/x_5.jpg',
      'https://example.com/images/sub/x_6.jpg',
    ],
    zipFile: 'https://example.com/files/x_3.zip',
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const List<ProductModel> purchasedProductModels = [
  ProductModel(
    id: 'product_002',
    productName: 'Product Two',
    price: '199.99',
    category: 'Ui Kits',
    marketingType: 'Latest',
    description: 'Product Two description',
    coverImage: 'https://example.com/images/cover/x_2.jpg',
    subImages: [
      'https://example.com/images/sub/x_3.jpg',
      'https://example.com/images/sub/x_4.jpg',
    ],
    zipFile: 'https://example.com/files/x_2.zip',
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_003',
    productName: 'Product Three',
    price: '1499.99',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Three description',
    coverImage: 'https://example.com/images/cover/x_3.jpg',
    subImages: [
      'https://example.com/images/sub/x_5.jpg',
      'https://example.com/images/sub/x_6.jpg',
    ],
    zipFile: 'https://example.com/files/x_3.zip',
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const String purchasedProductId = 'product_003';

final PurchaseProductsEntity purchasedProductEntity = PurchaseProductsEntity(
  purchaseId: '23434',
  price: '2000.00',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

final PurchaseProductsModel purchasedProductModel = PurchaseProductsModel(
  purchaseId: '23434',
  price: '2000.00',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

final purchasedProductJson = {
  'purchaseId': '23434',
  'price': '2000.00',
  'date': Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  'ids': ['product_003', 'product_001'],
};

final yearAndMonthParamsToGetPurchaseHistory = YearAndMonthParams(
  year: DateTime.now().year,
  month: DateTime.now().month,
);

const Map<String, int> purchaseHistoryByYearAndMonth = {
  '1': 2,
  '5': 10,
};

const double totalPurchaseAmountByYearAndMonth = 1699.98;

const double totalPurchaseAmountPercentageByYearAndMonth = 8.2;

const List<ProductEntity> topSellingProductEntitiesByYearAndMonth = [
  ProductEntity(
    id: 'product_002',
    productName: 'Product Two',
    price: '199.99',
    category: 'Ui Kits',
    marketingType: 'Latest',
    description: 'Product Two description',
    coverImage: 'https://example.com/images/cover/x_2.jpg',
    subImages: [
      'https://example.com/images/sub/x_3.jpg',
      'https://example.com/images/sub/x_4.jpg',
    ],
    zipFile: 'https://example.com/files/x_2.zip',
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
  ProductEntity(
    id: 'product_003',
    productName: 'Product Three',
    price: '1499.99',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Three description',
    coverImage: 'https://example.com/images/cover/x_3.jpg',
    subImages: [
      'https://example.com/images/sub/x_5.jpg',
      'https://example.com/images/sub/x_6.jpg',
    ],
    zipFile: 'https://example.com/files/x_3.zip',
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const List<ProductModel> topSellingProductModelsByYearAndMonth = [
  ProductModel(
    id: 'product_002',
    productName: 'Product Two',
    price: '199.99',
    category: 'Ui Kits',
    marketingType: 'Latest',
    description: 'Product Two description',
    coverImage: 'https://example.com/images/cover/x_2.jpg',
    subImages: [
      'https://example.com/images/sub/x_3.jpg',
      'https://example.com/images/sub/x_4.jpg',
    ],
    zipFile: 'https://example.com/files/x_2.zip',
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_003',
    productName: 'Product Three',
    price: '1499.99',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Three description',
    coverImage: 'https://example.com/images/cover/x_3.jpg',
    subImages: [
      'https://example.com/images/sub/x_5.jpg',
      'https://example.com/images/sub/x_6.jpg',
    ],
    zipFile: 'https://example.com/files/x_3.zip',
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const String purchasedProductName = 'Product Three';

const String purchasedProductUrl =
    'https://firebasestorage.googleapis.com/v0/b/digital-marketplace-22733.appspot.com/o/test%2Ftest_product.zip?alt=media&token=1a1554b2-146b-4f26-960b-a1a3db57';
