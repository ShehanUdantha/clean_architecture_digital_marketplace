import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';

const String cartedProductId = 'product_003';

const List<ProductEntity> cartedProductEntities = [
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

const List<ProductModel> cartedProductModels = [
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

const double cartedProductEntitiesListSubTotal = 1699.98;
const double cartedProductEntitiesListTransactionFee = 62.89926;
const double cartedProductEntitiesListTotalPrice = 1762.87926;

const List<String> cartedProductsIds = [
  'product_002',
  'product_003',
];
