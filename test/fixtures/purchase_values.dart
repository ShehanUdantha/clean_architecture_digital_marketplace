import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/data/models/cart/purchase_model.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/src/domain/entities/cart/purchase_entity.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/year_and_month_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<PurchaseEntity> purchaseEntities = [
  PurchaseEntity(
    purchaseId: '23434',
    price: '2499.98',
    dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
    products: ['product_003', 'product_001'],
  ),
];

final List<PurchaseModel> purchaseModels = [
  PurchaseModel(
    purchaseId: '23434',
    price: '2499.98',
    dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
    products: ['product_003', 'product_001'],
  ),
];

const List<String> purchasedProductIdList = [
  'product_003',
  'product_001',
];

const List<ProductEntity> purchasedProductEntities = [
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
  ProductEntity(
    id: 'product_001',
    productName: 'Product One',
    price: '999.99',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product One description',
    coverImage: 'https://example.com/images/cover/x_1.jpg',
    subImages: [
      'https://example.com/images/sub/x_1.jpg',
      'https://example.com/images/sub/x_2.jpg',
    ],
    zipFile: 'https://example.com/files/x_1.zip',
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
];

const List<ProductModel> purchasedProductModels = [
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
  ProductModel(
    id: 'product_001',
    productName: 'Product One',
    price: '999.99',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product One description',
    coverImage: 'https://example.com/images/cover/x_1.jpg',
    subImages: [
      'https://example.com/images/sub/x_1.jpg',
      'https://example.com/images/sub/x_2.jpg',
    ],
    zipFile: 'https://example.com/files/x_1.zip',
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
];

const String purchasedId = '23434';

final PurchaseEntity purchasedEntity = PurchaseEntity(
  purchaseId: '23434',
  price: '2499.98',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

final PurchaseModel purchasedModel = PurchaseModel(
  purchaseId: '23434',
  price: '2499.98',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

final purchasedJson = {
  'purchaseId': '23434',
  'price': '2499.98',
  'date': Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  'ids': ['product_003', 'product_001'],
};

final purchasedFailureJson = {
  'purchaseId': '23434',
  'price': '2499.98',
  'date': Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  'ids': ['product_003', 'product_001', 'product_008'],
};

const String purchasedIdTwo = '45373';

final purchasedJsonTwo = {
  'purchaseId': '45373',
  'price': '199.99',
  'date': Timestamp.fromDate(DateTime(2025, 2, 5, 2, 0, 0)),
  'ids': ['product_002'],
};

final yearAndMonthParamsToGetPurchaseHistory = YearAndMonthParams(
  year: 2025,
  month: 3,
);

final yearAndMonthParamsToGetPurchaseHistoryTwo = YearAndMonthParams(
  year: 2025,
  month: 5,
);

// key is the day, value is the number of products
const Map<String, int> purchaseHistoryByYearAndMonth = {
  '08': 2,
};

const double totalPurchaseAmountByYearAndMonth = 2499.98;

const double totalPurchaseAmountPercentageByYearAndMonth = 100.0;

const double totalPurchaseAmountPercentageByYearAndMonthTwo = 1150.052502625131;

const List<ProductEntity> topSellingProductEntitiesByYearAndMonth = [
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
  ProductEntity(
    id: 'product_001',
    productName: 'Product One',
    price: '999.99',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product One description',
    coverImage: 'https://example.com/images/cover/x_1.jpg',
    subImages: [
      'https://example.com/images/sub/x_1.jpg',
      'https://example.com/images/sub/x_2.jpg',
    ],
    zipFile: 'https://example.com/files/x_1.zip',
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
];

const List<ProductModel> topSellingProductModelsByYearAndMonth = [
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
  ProductModel(
    id: 'product_001',
    productName: 'Product One',
    price: '999.99',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product One description',
    coverImage: 'https://example.com/images/cover/x_1.jpg',
    subImages: [
      'https://example.com/images/sub/x_1.jpg',
      'https://example.com/images/sub/x_2.jpg',
    ],
    zipFile: 'https://example.com/files/x_1.zip',
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
];
