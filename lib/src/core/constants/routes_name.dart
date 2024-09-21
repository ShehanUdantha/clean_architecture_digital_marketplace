class AppRoutes {
  // common routes
  static const String splashPagePath = '/splash';
  static const String splashPageName = 'splash';

  static const String networkPagePath = '/network';
  static const String networkPageName = 'network';

  // auth routes
  static const String signInPagePath = '/sign-in';
  static const String signInPageName = 'signIn';

  static const String signUpPagePath = 'sign-up';
  static const String signUpPageName = 'signUp';

  static const String forgotPasswordPagePath = 'forgot-password';
  static const String forgotPasswordPageName = 'forgotPassword';

  static const String emailVerificationAndForgotPasswordPagePath =
      'email-verification-and-forgot-password';
  static const String emailVerificationAndForgotPasswordPageName =
      'emailVerificationAndForgotPassword';

  static const String authSettingsPagePath = 'auth-to-settings';
  static const String authSettingsPageName = 'authToSettings';

  // admin routes
  static const String adminPagePath = '/admin';
  static const String adminPageName = 'admin';

  // admin home sub routes
  static const String notificationAdminViewPagePath = 'notification-admin-view';
  static const String notificationAdminViewPageName = 'notificationAdminView';

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

  static const String notificationManagePagePath = 'notification-manage';
  static const String notificationManagePageName = 'notificationManage';

  static const String notificationSendPagePath = 'notification-send';
  static const String notificationSendPageName = 'notificationSend';

  // admin profile sub routes
  static const String adminInfoPagePath = 'admin-info';
  static const String adminInfoPageName = 'adminInfo';

  static const String adminSettingsPagePath = 'admin-settings';
  static const String adminSettingsPageName = 'adminSettings';

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

  static const String notificationViewPagePath = 'notification-view';
  static const String notificationViewPageName = 'notificationView';

  // profile sub routes
  static const String purchaseHistoryPagePath = 'purchase-history';
  static const String purchaseHistoryPageName = 'purchaseHistory';

  static const String purchaseProductViewPagePath = 'purchase-products-view';
  static const String purchaseProductViewPageName = 'purchaseProductView';

  static const String userInfoPagePath = 'user-info';
  static const String userInfoPageName = 'userInfo';

  static const String settingsPagePath = 'settings';
  static const String settingsPageName = 'settings';
}
