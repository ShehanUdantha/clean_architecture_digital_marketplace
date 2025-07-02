import 'package:Pixelcart/src/presentation/blocs/language/language_cubit.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_sources/local/notification/notification_local_data_source.dart';
import '../../data/data_sources/remote/auth/user_auth_remote_data_source.dart';
import '../../data/data_sources/remote/cart/cart_remote_data_source.dart';
import '../../data/data_sources/remote/cart/purchase_remote_data_source.dart';
import '../../data/data_sources/remote/category/category_remote_data_source.dart';
import '../../data/data_sources/remote/notification/notification_remote_data_source.dart';
import '../../data/data_sources/remote/product/product_remote_data_source.dart';
import '../../data/data_sources/remote/stripe/stripe_remote_data_source.dart';
import '../../data/data_sources/remote/user/user_remote_data_source.dart';
import '../../data/repositories/auth/user_auth_repository_impl.dart';
import '../../data/repositories/cart/cart_repository_impl.dart';
import '../../data/repositories/cart/purchase_repository_impl.dart';
import '../../data/repositories/category/category_repository_impl.dart';
import '../../data/repositories/notification/notification_count_repository_impl.dart';
import '../../data/repositories/notification/notification_repository_impl.dart';
import '../../data/repositories/product/product_repository_impl.dart';
import '../../data/repositories/stripe/stripe_repository_impl.dart';
import '../../data/repositories/user/user_repository_impl.dart';
import '../../domain/repositories/auth/user_auth_repository.dart';
import '../../domain/repositories/cart/cart_repository.dart';
import '../../domain/repositories/cart/purchase_repository.dart';
import '../../domain/repositories/category/category_repository.dart';
import '../../domain/repositories/notification/notification_count_repository.dart';
import '../../domain/repositories/notification/notification_repository.dart';
import '../../domain/repositories/product/product_repository.dart';
import '../../domain/repositories/stripe/stripe_repository.dart';
import '../../domain/repositories/user/user_repository.dart';
import '../../domain/usecases/auth/check_email_verification_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../domain/usecases/auth/get_auth_user_usecase.dart';
import '../../domain/usecases/auth/refresh_user_usecase.dart';
import '../../domain/usecases/auth/send_email_verification_usecase.dart';
import '../../domain/usecases/auth/user_sign_in_usecase.dart';
import '../../domain/usecases/auth/user_sign_out_usecase.dart';
import '../../domain/usecases/auth/user_sign_up_usecase.dart';
import '../../domain/usecases/cart/add_product_to_cart_usecase.dart';
import '../../domain/usecases/cart/get_all_carted_items_details_by_id_usecase.dart';
import '../../domain/usecases/cart/get_carted_items_usecase.dart';
import '../../domain/usecases/cart/purchase/download_product_by_product_id_usecase.dart';
import '../../domain/usecases/cart/purchase/get_all_purchase_history_by_month_usecase.dart';
import '../../domain/usecases/cart/purchase/get_all_purchase_history_by_user_id_usecase.dart';
import '../../domain/usecases/cart/purchase/get_all_purchase_items_by_product_id_usecase.dart';
import '../../domain/usecases/cart/purchase/get_all_purchase_total_balance_by_month_usecase.dart';
import '../../domain/usecases/cart/purchase/get_all_purchase_total_balance_percentage_usecase.dart';
import '../../domain/usecases/cart/purchase/get_top_sellings_products_by_month_usecase.dart';
import '../../domain/usecases/cart/purchase/set_cart_details_to_purchase_history_and_delete_cart_usecase.dart';
import '../../domain/usecases/cart/remove_product_from_cart_usecase.dart';
import '../../domain/usecases/category/add_category_usecase.dart';
import '../../domain/usecases/category/delete_category_usecase.dart';
import '../../domain/usecases/category/get_all_categories_usecase.dart';
import '../../domain/usecases/notification/delete_notification_usecase.dart';
import '../../domain/usecases/notification/get_all_notifications_usecase.dart';
import '../../domain/usecases/notification/get_notification_count_usecase.dart';
import '../../domain/usecases/notification/reset_notification_count_usecase.dart';
import '../../domain/usecases/notification/send_notification_usecase.dart';
import '../../domain/usecases/notification/update_notification_count_usecase.dart';
import '../../domain/usecases/product/add_favorite_usecase.dart';
import '../../domain/usecases/product/add_product_usecase.dart';
import '../../domain/usecases/product/delete_product_usecase.dart';
import '../../domain/usecases/product/edit_product_usecase.dart';
import '../../domain/usecases/product/get_all_products_usecase.dart';
import '../../domain/usecases/product/get_product_details_by_id_usecase.dart';
import '../../domain/usecases/product/get_products_by_marketing_types_usecase.dart';
import '../../domain/usecases/product/get_products_by_query_usecase.dart';
import '../../domain/usecases/stripe/make_payments_usecase.dart';
import '../../domain/usecases/user/get_all_users_usecase.dart';
import '../../domain/usecases/user/get_user_details_usecase.dart';
import '../../domain/usecases/user/get_user_type_usecase.dart';
import '../../presentation/blocs/admin_home/admin_home_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/cart/cart_bloc.dart';
import '../../presentation/blocs/category/category_bloc.dart';
import '../../presentation/blocs/forgot_password/forgot_password_bloc.dart';
import '../../presentation/blocs/network/network_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/product/product_bloc.dart';
import '../../presentation/blocs/product_details/product_details_bloc.dart';
import '../../presentation/blocs/purchase/purchase_bloc.dart';
import '../../presentation/blocs/sign_in/sign_in_bloc.dart';
import '../../presentation/blocs/sign_up/sign_up_bloc.dart';
import '../../presentation/blocs/stripe/stripe_bloc.dart';
import '../../presentation/blocs/user_home/user_home_bloc.dart';
import '../../presentation/blocs/users/users_bloc.dart';
import '../constants/variable_names.dart';
import 'notification_service.dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
  // firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);

  // http for network request
  sl.registerSingleton<http.Client>(http.Client());

  // local storage
  sl.registerSingleton<Box<dynamic>>(
    await Hive.openBox(AppVariableNames.notificationBox),
    instanceName: AppVariableNames.notificationBox,
  );
  sl.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  // data source
  sl.registerSingleton<UserAuthRemoteDataSource>(
    UserAuthRemoteDataSourceImpl(
      auth: sl(),
      fireStore: sl(),
      firebaseMessaging: sl(),
    ),
  );
  sl.registerSingleton<CategoryRemoteDataSource>(
    CategoryRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
    ),
  );
  sl.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
      storage: sl(),
    ),
  );
  sl.registerSingleton<UserRemoteDataSource>(
    UserRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
    ),
  );
  sl.registerSingleton<CartRemoteDataSource>(
    CartRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
    ),
  );
  sl.registerSingleton<StripeRemoteDataSource>(
    StripRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerSingleton<PurchaseRemoteDataSource>(
    PurchaseRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
    ),
  );
  sl.registerSingleton<NotificationRemoteDataSource>(
    NotificationRemoteDataSourceImpl(
      fireStore: sl(),
      auth: sl(),
      client: sl(),
    ),
  );
  sl.registerSingleton<NotificationLocalDataSource>(
    NotificationLocalDataSourceImpl(
      notificationBox:
          sl<Box<dynamic>>(instanceName: AppVariableNames.notificationBox),
    ),
  );

  // repository
  sl.registerSingleton<UserAuthRepository>(
    UserAuthRepositoryImpl(
      userAuthRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(
      categoryRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(
      productRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<UserRepository>(
    UserRepositoryImpl(
      userRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<CartRepository>(
    CartRepositoryImpl(
      cartRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<StripeRepository>(
    StripeRepositoryImpl(
      stripeRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<PurchaseRepository>(
    PurchaseRepositoryImpl(
      purchaseRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(
      notificationRemoteDataSource: sl(),
    ),
  );
  sl.registerSingleton<NotificationCountRepository>(
    NotificationCountRepositoryImpl(
      notificationLocalDataSource: sl(),
    ),
  );

  // useCase
  // auth
  sl.registerSingleton<UserSignUpUseCase>(
    UserSignUpUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<SendEmailVerificationUseCase>(
    SendEmailVerificationUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<UserSignInUseCase>(
    UserSignInUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<CheckEmailVerificationUseCase>(
    CheckEmailVerificationUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<GetUserTypeUseCase>(
    GetUserTypeUseCase(userRepository: sl()),
  );
  sl.registerSingleton<GetAuthUserUseCase>(
    GetAuthUserUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<UserSignOutUseCase>(
    UserSignOutUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<ForgotPasswordUseCase>(
    ForgotPasswordUseCase(userAuthRepository: sl()),
  );
  sl.registerSingleton<RefreshUserUseCase>(
    RefreshUserUseCase(userAuthRepository: sl()),
  );

  // admin
  // category
  sl.registerSingleton<AddCategoryUseCase>(
    AddCategoryUseCase(categoryRepository: sl()),
  );
  sl.registerSingleton<GetAllCategoriesUseCase>(
    GetAllCategoriesUseCase(categoryRepository: sl()),
  );
  sl.registerSingleton<DeleteCategoryUseCase>(
    DeleteCategoryUseCase(categoryRepository: sl()),
  );
  // product
  sl.registerSingleton<AddProductUseCase>(
    AddProductUseCase(productRepository: sl()),
  );
  sl.registerSingleton<EditProductUseCase>(
    EditProductUseCase(productRepository: sl()),
  );
  sl.registerSingleton<GetAllProductsUseCase>(
    GetAllProductsUseCase(productRepository: sl()),
  );
  sl.registerSingleton<DeleteProductUseCase>(
    DeleteProductUseCase(productRepository: sl()),
  );
  // users
  sl.registerSingleton<GetAllUsersUseCase>(
    GetAllUsersUseCase(userRepository: sl()),
  );
  // notifications
  sl.registerSingleton<SendNotificationUseCase>(
    SendNotificationUseCase(notificationRepository: sl()),
  );
  sl.registerSingleton<GetAllNotificationsUseCase>(
    GetAllNotificationsUseCase(notificationRepository: sl()),
  );
  sl.registerSingleton<DeleteNotificationUseCase>(
    DeleteNotificationUseCase(notificationRepository: sl()),
  );
  sl.registerSingleton<UpdateNotificationCountUseCase>(
    UpdateNotificationCountUseCase(notificationCountRepository: sl()),
  );
  sl.registerSingleton<GetNotificationCountUseCase>(
    GetNotificationCountUseCase(notificationCountRepository: sl()),
  );
  sl.registerSingleton<ResetNotificationCountUseCase>(
    ResetNotificationCountUseCase(notificationCountRepository: sl()),
  );
  // purchases
  sl.registerSingleton<GetAllPurchaseHistoryByMonthUseCase>(
    GetAllPurchaseHistoryByMonthUseCase(purchaseRepository: sl()),
  );
  sl.registerSingleton<GetAllPurchaseBalanceByMonthUseCase>(
    GetAllPurchaseBalanceByMonthUseCase(purchaseRepository: sl()),
  );
  sl.registerSingleton<GetAllPurchaseBalancePercentageByMonthUseCase>(
    GetAllPurchaseBalancePercentageByMonthUseCase(purchaseRepository: sl()),
  );
  sl.registerSingleton<GetTopSellingProductsByMonthUseCase>(
    GetTopSellingProductsByMonthUseCase(purchaseRepository: sl()),
  );

  // user
  // user details
  sl.registerSingleton<GetUserDetailsUseCase>(
    GetUserDetailsUseCase(userRepository: sl()),
  );
  // products
  sl.registerSingleton<GetProductsByMarketingTypeUseCase>(
    GetProductsByMarketingTypeUseCase(productRepository: sl()),
  );
  sl.registerSingleton<GetProductsByQueryUseCase>(
    GetProductsByQueryUseCase(productRepository: sl()),
  );
  sl.registerSingleton<GetProductDetailsByIdUseCase>(
    GetProductDetailsByIdUseCase(productRepository: sl()),
  );
  sl.registerSingleton<AddFavoriteUseCase>(
    AddFavoriteUseCase(productRepository: sl()),
  );
  // cart
  sl.registerSingleton<AddProductToCartUseCase>(
    AddProductToCartUseCase(cartRepository: sl()),
  );
  sl.registerSingleton<GetCartedItemsUseCase>(
    GetCartedItemsUseCase(cartRepository: sl()),
  );
  sl.registerSingleton<GetAllCartedItemsDetailsByIdUseCase>(
    GetAllCartedItemsDetailsByIdUseCase(cartRepository: sl()),
  );
  sl.registerSingleton<RemoveProductFromCartUseCase>(
    RemoveProductFromCartUseCase(cartRepository: sl()),
  );
  sl.registerSingleton<SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase>(
    SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase(cartRepository: sl()),
  );
  // stripe
  sl.registerSingleton<MakePaymentsUseCase>(
    MakePaymentsUseCase(stripeRepository: sl()),
  );
  // purchase
  sl.registerSingleton<GetAllPurchaseHistoryByUserIdUseCase>(
    GetAllPurchaseHistoryByUserIdUseCase(purchaseRepository: sl()),
  );
  sl.registerSingleton<GetAllPurchaseItemsByItsProductIdsUseCase>(
    GetAllPurchaseItemsByItsProductIdsUseCase(purchaseRepository: sl()),
  );
  sl.registerSingleton<DownloadProductByProductIdUsecase>(
    DownloadProductByProductIdUsecase(purchaseRepository: sl()),
  );

  // bloc
  // auth
  sl.registerFactory<SignUpBloc>(
    () => SignUpBloc(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<SignInBloc>(
    () => SignInBloc(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(
      sl(),
    ),
  );
  // admin
  // admin home
  sl.registerFactory<AdminHomeBloc>(
    () => AdminHomeBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  // category
  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      sl(),
      sl(),
      sl(),
    ),
  );
  // product
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  // users
  sl.registerFactory<UsersBloc>(
    () => UsersBloc(
      sl(),
    ),
  );
  // notifications
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );

  // user
  // user home
  sl.registerFactory<UserHomeBloc>(
    () => UserHomeBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );

  // cart
  sl.registerFactory<CartBloc>(
    () => CartBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  // stripe
  sl.registerFactory<StripeBloc>(
    () => StripeBloc(
      sl(),
    ),
  );
  // purchase
  sl.registerFactory<PurchaseBloc>(
    () => PurchaseBloc(
      sl(),
      sl(),
      sl(),
    ),
  );

  // network
  sl.registerSingleton<Connectivity>(Connectivity());

  sl.registerFactory<NetworkBloc>(
    () => NetworkBloc(
      sl(),
    ),
  );

  // theme
  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(
      sl(),
    ),
  );

  // language
  sl.registerFactory<LanguageCubit>(
    () => LanguageCubit(
      sl(),
    ),
  );

  // notifications
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin(),
  );
  sl.registerSingleton<NotificationService>(
    NotificationService(
      flutterLocalNotificationsPlugin: sl(),
      firebaseMessaging: sl(),
    ),
  );
}
