import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';

import 'category_values.dart';

const String marketingTypeFeatured = 'Featured';

const String newProductName = 'test_product_six';
const String newProductPrice = '500.00';
const String newProductDescription = 'test product description';

const ProductEntity newProductEntity = ProductEntity(
  productName: newProductName,
  price: newProductPrice,
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: newProductDescription,
  coverImage: null,
  subImages: [],
  zipFile: null,
  likes: [],
  status: '',
);

const String editProductId = 'product_006';
const String editProductDescription = 'Product Six description';
const String editProductStatus = 'active';

const ProductEntity editProductEntity = ProductEntity(
  id: editProductId,
  productName: newProductName,
  price: newProductPrice,
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: editProductDescription,
  coverImage: null,
  subImages: [],
  zipFile: null,
  likes: [],
  status: editProductStatus,
);

const List<ProductEntity> fontsCategoryProductEntities = [
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

const List<ProductModel> fontsCategoryProductModels = [
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

const String productId = 'product_003';

const ProductModel productIdThreeModel = ProductModel(
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
);

const ProductModel productIdThreeNewModel = ProductModel(
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
  likes: ['user_02', 'user_01', 'user_05'],
  status: 'active',
);

const ProductEntity productIdThreeEntity = ProductEntity(
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
);

const ProductEntity productIdThreeNewEntity = ProductEntity(
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
  likes: ['user_02', 'user_01', 'user_05'],
  status: 'active',
);

const ProductEntity productEntity = ProductEntity(
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
);

const ProductModel productModel = ProductModel(
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
);

const productJson = {
  'id': 'product_001',
  'productName': 'Product One',
  'price': '999.99',
  'category': 'Mockups',
  'marketingType': 'Trending',
  'description': 'Product One description',
  'coverImage': 'https://example.com/images/cover/x_1.jpg',
  'subImages': [
    'https://example.com/images/sub/x_1.jpg',
    'https://example.com/images/sub/x_2.jpg',
  ],
  'zipFile': 'https://example.com/files/x_1.zip',
  'dateCreated': '2025-01-18',
  'likes': ['user_01', 'user_02'],
  'status': 'active',
};

const List<ProductModel> featuredMarketingTypeProducts = [
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

const List<ProductEntity> featuredMarketingTypeProductEntities = [
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

const List<ProductEntity> trendingMarketingTypeProductEntities = [
  ProductEntity(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four new description',
    coverImage: 'https://example.com/images/cover/y_1.jpg',
    subImages: [
      'https://example.com/images/sub/y_1.jpg',
      'https://example.com/images/sub/y_2.jpg',
    ],
    zipFile: 'https://example.com/files/y_3.zip',
    dateCreated: '2025-01-19',
    likes: ['user_01'],
    status: 'active',
  ),
];

const List<ProductEntity> latestMarketingTypeProductEntities = [
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
];

const String productSearchQuery = 'Fonts Pack';

const List<ProductModel> searchQueryResultProductModels = [
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

const List<ProductEntity> searchQueryResultProductEntities = [
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

const int productSubImageNumber = 5;
