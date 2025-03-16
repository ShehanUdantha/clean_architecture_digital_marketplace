import 'package:Pixelcart/src/data/models/category/category_model.dart';
import 'package:Pixelcart/src/data/models/notification/notification_model.dart';
import 'package:Pixelcart/src/data/models/product/product_model.dart';
import 'package:Pixelcart/src/data/models/product/purchase_products_model.dart';
import 'package:Pixelcart/src/data/models/stripe/stripe_model.dart';
import 'package:Pixelcart/src/data/models/user/user_model.dart';
import 'package:Pixelcart/src/domain/entities/category/category_entity.dart';
import 'package:Pixelcart/src/domain/entities/notification/notification_entity.dart';
import 'package:Pixelcart/src/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/src/domain/entities/stripe/stripe_entity.dart';
import 'package:Pixelcart/src/domain/entities/user/user_entity.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_in_params.dart';
import 'package:Pixelcart/src/domain/usecases/auth/sign_up_params.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/year_and_month_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// * auth
const signUpParams = SignUpParams(
  userName: 'testUser',
  email: 'test@example.com',
  password: 'password123',
);

const signInParams = SignInParams(
  email: 'test@example.com',
  password: 'password123',
);

const String forgotPwEmail = 'test@example.com';

const userId = 'sampleId123';

// * users
const String userTypeForAll = 'All Account';
const String userTypeForUser = 'User';
const String userTypeForAdmin = 'Admin';

const List<UserModel> allTypeOfDummyUsers = [
  UserModel(
    userId: 'user_01',
    userType: 'User',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserModel(
    userId: 'user_02',
    userType: 'Admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
  UserModel(
    userId: 'user_03',
    userType: 'User',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
];

const List<UserModel> onlyDummyUsers = [
  UserModel(
    userId: 'user_01',
    userType: 'User',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    deviceToken: 'token123',
  ),
  UserModel(
    userId: 'user_03',
    userType: 'User',
    userName: 'Mike Johnson',
    email: 'mike.johnson@example.com',
    password: 'password789',
    deviceToken: 'token789',
  ),
];

const List<UserModel> onlyDummyAdmins = [
  UserModel(
    userId: 'user_02',
    userType: 'Admin',
    userName: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'password456',
    deviceToken: 'token456',
  ),
];

const userDetailsDummyModel = UserModel(
  userId: 'user_02',
  userType: 'Admin',
  userName: 'Jane Smith',
  email: 'jane.smith@example.com',
  password: 'password456',
  deviceToken: 'token456',
);

const String userTypeAdmin = 'Admin';
const String dummyUserIdToGetUserType = 'user_02';

const userDetailsDummy = UserModel(
  userId: 'user_06',
  userType: 'User',
  userName: 'Sam Smith',
  email: 'sam.smith@example.com',
  password: 'password90',
  deviceToken: 'token342',
);

const userDetailsDummyJson = {
  'userId': 'user_06',
  'userType': 'User',
  'userName': 'Sam Smith',
  'email': 'sam.smith@example.com',
  'password': 'password90',
  'deviceToken': 'token342',
};

const userDetailsDummyEntity = UserEntity(
  userId: 'user_06',
  userType: 'User',
  userName: 'Sam Smith',
  email: 'sam.smith@example.com',
  password: 'password90',
  deviceToken: 'token342',
);

// * payments
const double paymentAmount = 1000.00;

const dummyStripeModel = StripeModel(
  id: 'stripe_12345',
  amount: 1000,
  client_secret: 'sk_test_4eC39HqLyjWDjt',
  currency: 'USD',
);

const dummyStripeJson = {
  'id': 'stripe_12345',
  'amount': 1000,
  'client_secret': 'sk_test_4eC39HqLyjWDjt',
  'currency': 'USD',
};

const dummyStripeEntity = StripeEntity(
  id: 'stripe_12345',
  amount: 1000,
  client_secret: 'sk_test_4eC39HqLyjWDjt',
  currency: 'USD',
);

// * products
const String fakeProductId = 'product_005';

const List<ProductModel> dummyProducts = [
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
];

const List<String> cartedDummyItemsIds = [
  'product_001',
  'product_003',
];

const ProductModel dummyProduct = ProductModel(
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

final dummyProductJson = {
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

const ProductModel dummyProductTwo = ProductModel(
  id: null,
  productName: 'Product Four',
  price: '200.00',
  category: 'Mockups',
  marketingType: 'Trending',
  description: 'Product Four description',
  coverImage: 'document/y_1.jpg',
  subImages: [
    'document/y_2.jpg',
    'document/y_3.jpg',
  ],
  zipFile: 'document/y_4.zip',
  dateCreated: '2025-01-19',
  likes: [],
  status: '',
);

const ProductEntity dummyProductEntity = ProductEntity(
  productName: 'Product Four',
  price: '200.00',
  category: 'Mockups',
  marketingType: 'Trending',
  description: 'Product Four description',
  coverImage: 'document/y_1.jpg',
  subImages: [
    'document/y_2.jpg',
    'document/y_3.jpg',
  ],
  zipFile: 'document/y_4.zip',
  dateCreated: '2025-01-19',
  likes: [],
  status: '',
);

const ProductEntity dummyProductEntityForEdit = ProductEntity(
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
  sharedSubImages: [],
);

const List<ProductModel> dummyFontsCategoryProducts = [
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

const String dummyMarketingType = 'Featured';

const List<ProductModel> dummyFeaturedMarketingTypeProducts = [
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

const String fakeProductSearchQuery = 'Fonts Pack';

const List<ProductModel> searchQueryDummyResult = [
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

// * purchase
const Map<String, int> fakePurchaseHistoryByMonth = {
  '1': 2,
  '5': 10,
};

final yearAndMonthParams = YearAndMonthParams(
  year: 2025,
  month: 1,
);

final List<PurchaseProductsModel> dummyPurchasedProducts = [
  PurchaseProductsModel(
    purchaseId: '23434',
    price: '2000.00',
    dateCreated: Timestamp.now(),
    products: ['product_003', 'product_001'],
  ),
];

final dummyPurchaseProduct = PurchaseProductsModel(
  purchaseId: '23434',
  price: '2000.00',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

final dummyPurchaseProductJson = {
  'purchaseId': '23434',
  'price': '2000.00',
  'date': Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  'ids': ['product_003', 'product_001'],
};

final dummyPurchaseProductEntity = PurchaseProductsModel(
  purchaseId: '23434',
  price: '2000.00',
  dateCreated: Timestamp.fromDate(DateTime(2025, 3, 8, 2, 0, 0)),
  products: ['product_003', 'product_001'],
);

const List<String> fakeProductIdList = ['product_003', 'product_002'];

const double fakeTotalPurchaseAmount = 10000.00;
const double fakeTotalPurchaseAmountPercentage = 14.5;

const List<ProductModel> dummyTopSellingProducts = [
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

const String fakeTotalCartedItemsAmount = '8000.00';

// * category
const String dummyProductCategoryType = 'Icons';
const String fakeProductCategoryId = '189';
const String dummyFontCategoryType = 'Fonts';

final List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '34534',
    name: 'Fonts',
    dateCreated: '2025-01-16',
  ),
  CategoryModel(
    id: '64634',
    name: 'Ui Kits',
    dateCreated: '2025-01-15',
  ),
];

const dummyCategory = CategoryModel(
  id: '34534',
  name: 'Fonts',
  dateCreated: '2025-01-16',
);

const dummyCategoryJson = {
  'id': '34534',
  'name': 'Fonts',
  'dateCreated': '2025-01-16',
};

const dummyCategoryEntity = CategoryEntity(
  id: '34534',
  name: 'Fonts',
  dateCreated: '2025-01-16',
);

// * notifications
const String dummyUserIdToGetNotifications = 'user_02';

const int fakeNotificationCount = 5;
const int fakeNotificationNewCount = 6;

const String fakeNotificationId = 'notification_002';

final dummyNotifications = [
  NotificationModel(
    id: 'notification_001',
    title: 'Welcome to the App!',
    description:
        'Thank you for signing up. Explore the features and enjoy your journey with us.',
    dateCreated: '2025-01-15',
  ),
  NotificationModel(
    id: 'notification_002',
    title: 'Update Available',
    description:
        'A new version of the app is now available. Update to enjoy the latest features.',
    dateCreated: '2025-01-18',
  ),
];

const dummyNotification = NotificationModel(
  id: 'notification_002',
  title: 'Maintenance Scheduled',
  description:
      'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.',
  dateCreated: '2025-01-19',
);

const dummyNotificationJson = {
  'id': 'notification_002',
  'title': 'Maintenance Scheduled',
  'description':
      'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.',
  'dateCreated': '2025-01-19',
};

const dummyNotificationEntity = NotificationEntity(
  title: 'Maintenance Scheduled',
  description:
      'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.',
  dateCreated: '2025-01-19',
);

const dummyNotificationEntityTwo = NotificationEntity(
  id: 'notification_002',
  title: 'Maintenance Scheduled',
  description:
      'We have a scheduled maintenance on January 20th, 2025, from 2 AM to 5 AM.',
  dateCreated: '2025-01-19',
);
