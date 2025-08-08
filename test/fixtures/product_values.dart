import 'dart:io';
import 'dart:typed_data';

import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';

import 'auth_values.dart';
import 'category_values.dart';

const String marketingTypeFeatured = 'Featured';
const String marketingTypeTrending = 'Trending';
const String marketingTypeLatest = 'Latest';

ProductEntity newProductEntity = ProductEntity(
  productName: 'Product Five',
  price: '500.00',
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: 'Product Five description',
  coverImage: Uint8List(0),
  subImages: [Uint8List(0)],
  zipFile: File('test.zip'),
  likes: [],
  status: '',
);

ProductModel newProductModel = ProductModel(
  id: 'product_005',
  productName: 'Product Five',
  price: '500.00',
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: 'Product Five description',
  coverImage: 'https://example.com/images/cover/x_5.jpg',
  subImages: [
    'https://example.com/images/sub/x_9.jpg',
    'https://example.com/images/sub/x_10.jpg',
  ],
  zipFile: 'https://example.com/files/x_5.zip',
  dateCreated: '2025-07-16',
  likes: [],
  status: 'active',
);

ProductModel beforeEditProductModel = ProductModel(
  id: 'product_005',
  productName: 'Product Five',
  price: '500.00',
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: 'Product Five description',
  coverImage: 'https://example.com/images/cover/x_5.jpg',
  subImages: [
    'https://example.com/images/sub/x_9.jpg',
    'https://example.com/images/sub/x_10.jpg',
  ],
  zipFile: 'https://example.com/files/x_5.zip',
  dateCreated: '2025-07-16',
  likes: [],
  status: 'active',
);

ProductEntity editedProductEntity = ProductEntity(
  id: 'product_005',
  productName: 'Product Five',
  price: '800.00',
  category: categoryTypeFont,
  marketingType: marketingTypeFeatured,
  description: 'Product Five description (more details)',
  coverImage: 'https://example.com/images/cover/x_5.jpg',
  subImages: [Uint8List(0)],
  zipFile: 'https://example.com/files/x_5.zip',
  sharedSubImages: [
    'https://example.com/images/sub/x_9.jpg',
    'https://example.com/images/sub/x_10.jpg',
  ],
  dateCreated: '2025-07-16',
  likes: [],
  status: 'active',
);

final ProductEntity expectedEditedProductEntityInBloc = ProductEntity(
  id: editedProductEntity.id!,
  productName: editedProductEntity.productName,
  price: editedProductEntity.price,
  category: editedProductEntity.category,
  marketingType: editedProductEntity.marketingType,
  description: editedProductEntity.description,
  coverImage: editedProductEntity.coverImage,
  subImages: editedProductEntity.subImages,
  zipFile: editedProductEntity.zipFile,
  sharedSubImages: editedProductEntity.sharedSubImages,
  likes: editedProductEntity.likes,
  status: editedProductEntity.status,
);

const List<ProductEntity> productsEntitiesWithZipFiles = [
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
  ProductEntity(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_7.jpg',
      'https://example.com/images/sub/x_8.jpg',
    ],
    zipFile: 'https://example.com/files/x_5.zip',
    dateCreated: '2025-01-19',
    likes: ['user_01'],
    status: 'active',
  ),
  ProductEntity(
    id: 'product_005',
    productName: 'Product Five',
    price: '500.00',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Five description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_9.jpg',
      'https://example.com/images/sub/x_10.jpg',
    ],
    zipFile: 'https://example.com/files/x_5.zip',
    dateCreated: '2025-07-16',
    likes: [],
    status: 'active',
  ),
];

const List<ProductModel> productsModelsWithZipFiles = [
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
  ProductModel(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_7.jpg',
      'https://example.com/images/sub/x_8.jpg',
    ],
    zipFile: 'https://example.com/files/x_5.zip',
    dateCreated: '2025-01-19',
    likes: ['user_01'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_005',
    productName: 'Product Five',
    price: '500.00',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Five description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_9.jpg',
      'https://example.com/images/sub/x_10.jpg',
    ],
    zipFile: 'https://example.com/files/x_5.zip',
    dateCreated: '2025-07-16',
    likes: [],
    status: 'active',
  ),
];

const List<ProductModel> productsModels = [
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
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
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
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_7.jpg',
      'https://example.com/images/sub/x_8.jpg',
    ],
    dateCreated: '2025-01-19',
    likes: ['user_01'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_005',
    productName: 'Product Five',
    price: '500.00',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Five description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_9.jpg',
      'https://example.com/images/sub/x_10.jpg',
    ],
    dateCreated: '2025-07-16',
    likes: [],
    status: 'active',
  ),
];

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
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const List<ProductModel> fontsCategoryProductModelsWithoutZipFiles = [
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
  dateCreated: '2025-01-16',
  likes: ['user_02', 'user_01'],
  status: 'active',
);

const ProductModel productIdThreeFavoriteModel = ProductModel(
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
  dateCreated: '2025-01-16',
  likes: ['user_02', 'user_01', userUserId],
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
  dateCreated: '2025-01-16',
  likes: ['user_02', 'user_01'],
  status: 'active',
);

const ProductEntity productIdThreeFavoriteEntity = ProductEntity(
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
  dateCreated: '2025-01-16',
  likes: ['user_02', 'user_01', userUserId],
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
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
  ProductEntity(
    id: 'product_005',
    productName: 'Product Five',
    price: '500.00',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Five description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_9.jpg',
      'https://example.com/images/sub/x_10.jpg',
    ],
    dateCreated: '2025-07-16',
    likes: [],
    status: 'active',
  ),
];

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
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_005',
    productName: 'Product Five',
    price: '500.00',
    category: 'Fonts',
    marketingType: 'Featured',
    description: 'Product Five description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_9.jpg',
      'https://example.com/images/sub/x_10.jpg',
    ],
    dateCreated: '2025-07-16',
    likes: [],
    status: 'active',
  ),
];

const List<ProductEntity> trendingMarketingTypeProductEntities = [
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
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
  ProductEntity(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_7.jpg',
      'https://example.com/images/sub/x_8.jpg',
    ],
    dateCreated: '2025-01-19',
    likes: ['user_01'],
    status: 'active',
  ),
];

const List<ProductModel> trendingMarketingTypeProductModels = [
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
    dateCreated: '2025-01-18',
    likes: ['user_01', 'user_02'],
    status: 'active',
  ),
  ProductModel(
    id: 'product_004',
    productName: 'Product Four',
    price: '250.00',
    category: 'Mockups',
    marketingType: 'Trending',
    description: 'Product Four description',
    coverImage: 'https://example.com/images/cover/x_5.jpg',
    subImages: [
      'https://example.com/images/sub/x_7.jpg',
      'https://example.com/images/sub/x_8.jpg',
    ],
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
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
];

const List<ProductModel> latestMarketingTypeProductModel = [
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
    dateCreated: '2025-01-17',
    likes: ['user_03'],
    status: 'active',
  ),
];

const String productSearchQuery = 'Product Three';
const String productSearchQueryTwo = 'Product Ten';

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
    dateCreated: '2025-01-16',
    likes: ['user_02', 'user_01'],
    status: 'active',
  ),
];

const int productSubImageNumber = 5;
