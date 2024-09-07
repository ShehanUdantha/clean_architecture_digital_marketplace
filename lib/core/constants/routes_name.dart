class AppRoutes {
  // common routes
  static const String splashPagePath = '/splash';
  static const String splashPageName = 'splash';

  static const String networkPagePath = '/network';
  static const String networkPageName = 'network';

  // auth routes
  static const String signUpPagePath = '/sign-up';
  static const String signUpPageName = 'signUp';

  static const String signInPagePath = '/sign-in';
  static const String signInPageName = 'signIn';

  static const String forgotPasswordPagePath = '/forgot-password';
  static const String forgotPasswordPageName = 'forgotPassword';

  static const String emailVerificationAndForgotPasswordPagePath =
      '/email-verification-and-forgot-password';
  static const String emailVerificationAndForgotPasswordPageName =
      'emailVerificationAndForgotPassword';

  // admin routes
  static const String adminPagePath = '/admin';
  static const String adminPageName = 'admin';

  static const String toolsPagePath = '/tools';
  static const String toolsPageName = 'tools';

  static const String adminProfilePagePath = '/admin-profile';
  static const String adminProfilePageName = 'adminProfile';

  // admin tools sub routes
  static const String productsManagePagePath = 'products-manage';
  static const String productsManagePageName = 'productsManage';

  static const String productsAddPagePath = 'products-add';
  static const String productsAddPageName = 'productsAdd';

  static const String categoriesManagePagePath = 'categories-manage';
  static const String categoriesManagePageName = 'categoriesManage';

  static const String usersManagePagePath = 'users-manage';
  static const String usersManagePageName = 'usersManage';

  // admin profile sub routes
  static const String adminInfoPagePath = 'admin-info';
  static const String adminInfoPageName = 'adminInfo';

  // user routes
  static const String homePagePath = '/home';
  static const String homePageName = 'home';

  static const String cartPagePath = '/cart';
  static const String cartPageName = 'cart';

  static const String profilePagePath = '/profile';
  static const String profilePageName = 'profile';

  // home sub routes
  static const String productViewPagePath = 'product-view';
  static const String productViewPageName = 'productView';

  static const String viewAllProductsPagePath = 'view-all-products';
  static const String viewAllProductsPageName = 'viewAllProducts';

  // profile sub routes
  static const String purchaseHistoryPagePath = 'purchase-history';
  static const String purchaseHistoryPageName = 'purchaseHistory';

  static const String purchaseProductViewPagePath = 'purchase-products-view';
  static const String purchaseProductViewPageName = 'purchaseProductView';

  static const String userInfoPagePath = 'user-info';
  static const String userInfoPageName = 'userInfo';
}
