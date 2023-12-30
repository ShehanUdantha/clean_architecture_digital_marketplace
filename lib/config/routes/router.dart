import 'package:Pixelcart/presentation/pages/profile/purchase_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/routes_name.dart';
import '../../core/utils/enum.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/pages/admin_home/admin_home_page.dart';
import '../../presentation/pages/admin_tools/category_manage_page.dart';
import '../../presentation/pages/admin_tools/product_add_edit_page.dart';
import '../../presentation/pages/admin_tools/product_manage_page.dart';
import '../../presentation/pages/admin_tools/tools_page.dart';
import '../../presentation/pages/admin_tools/user_manage_page.dart';
import '../../presentation/pages/auth/email_verification_and_forgot_password_page.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/sign_in_page.dart';
import '../../presentation/pages/auth/sign_up_page.dart';
import '../../presentation/pages/base/base_page.dart';
import '../../presentation/pages/base/splash_screen.dart';
import '../../presentation/pages/cart/cart_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/profile/purchase_products_view_page.dart';
import '../../presentation/pages/user_home/product_view_page.dart';
import '../../presentation/pages/user_home/user_home_page.dart';
import '../../presentation/pages/user_home/view_all_products_page.dart';

// private navigators
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellHomeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final shellCartNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellCart');
final shellProfileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final shellAdminNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAdmin');
final shellToolsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTools');
final shellAdminProfileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellAdminProfile');

GoRouter goRouter = GoRouter(
  initialLocation: AppRoutes.splashPagePath,
  navigatorKey: rootNavigatorKey,
  routes: [
    // splash page
    GoRoute(
      name: AppRoutes.splashPageName,
      path: AppRoutes.splashPagePath,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        );
      },
      redirect: (context, state) {
        final authState = context.watch<AuthBloc>().state;

        if (authState.status == BlocStatus.success) {
          if (authState.user!.emailVerified) {
            if (authState.userType == UserTypes.admin.name) {
              return state.namedLocation(AppRoutes.adminPageName);
            }
            if (authState.userType == UserTypes.user.name) {
              return state.namedLocation(AppRoutes.homePageName);
            }
          } else {
            return state.namedLocation(AppRoutes.signInPageName);
          }
        } else if (authState.status == BlocStatus.error ||
            authState.status == BlocStatus.initial) {
          return state.namedLocation(AppRoutes.signInPageName);
        }

        return state.namedLocation(AppRoutes.splashPageName);
      },
    ),

    // auth pages
    GoRoute(
      name: AppRoutes.signInPageName,
      path: AppRoutes.signInPagePath,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SignInPage(),
        );
      },
    ),
    GoRoute(
      name: AppRoutes.signUpPageName,
      path: AppRoutes.signUpPagePath,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SignUpPage(),
        );
      },
    ),
    GoRoute(
      name: AppRoutes.forgotPasswordPageName,
      path: AppRoutes.forgotPasswordPagePath,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordPage(),
        );
      },
    ),
    GoRoute(
      name: AppRoutes.emailVerificationAndForgotPasswordPageName,
      path: AppRoutes.emailVerificationAndForgotPasswordPagePath,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        final goBackPage = state.uri.queryParameters['page'];
        final isForgot = state.uri.queryParameters['isForgot'];
        return EmailVerificationPage(
          email: email!,
          page: goBackPage!,
          isForgot: isForgot == 'true',
        );
      },
    ),

    // user base page
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BasePage(
          statefulNavigationShell: navigationShell,
        );
      },
      branches: [
        //home branch
        StatefulShellBranch(
          navigatorKey: shellHomeNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.homePageName,
              path: AppRoutes.homePagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const UserHomePage(),
                );
              },
              // sub routes
              routes: [
                GoRoute(
                  name: AppRoutes.productViewPageName,
                  path: AppRoutes.productViewPagePath,
                  builder: (context, state) {
                    final backRoute = state.uri.queryParameters['route'];
                    final productId = state.uri.queryParameters['id'];
                    final type = state.uri.queryParameters['type'];

                    return ProductViewPage(
                      routeName: backRoute!,
                      productId: productId!,
                      type: type,
                    );
                  },
                ),
                GoRoute(
                  name: AppRoutes.viewAllProductsPageName,
                  path: AppRoutes.viewAllProductsPagePath,
                  builder: (context, state) {
                    final type = state.uri.queryParameters['type'];
                    return ViewAllProductsPage(
                      type: type!,
                    );
                  },
                  // sub routes
                ),
              ],
            ),
          ],
        ),

        // cart branch
        StatefulShellBranch(
          navigatorKey: shellCartNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.cartPageName,
              path: AppRoutes.cartPagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const CartPage(),
                );
              },
            ),
          ],
        ),

        // profile branch
        StatefulShellBranch(
          navigatorKey: shellProfileNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.profilePageName,
              path: AppRoutes.profilePagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                );
              },
              // sub routes
              routes: [
                GoRoute(
                  name: AppRoutes.purchaseHistoryPageName,
                  path: AppRoutes.purchaseHistoryPagePath,
                  parentNavigatorKey: shellProfileNavigatorKey,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const PurchaseHistoryPage(),
                    );
                  },
                ),
                GoRoute(
                  name: AppRoutes.purchaseProductViewPageName,
                  path: AppRoutes.purchaseProductViewPagePath,
                  builder: (context, state) {
                    List<String> productIdsList = state.extra as List<String>;

                    return PurchaseProductViewPage(
                      productIds: productIdsList,
                    );
                  },
                  // sub routes
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // admin base page
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BasePage(
          statefulNavigationShell: navigationShell,
        );
      },
      branches: [
        //admin branch
        StatefulShellBranch(
          navigatorKey: shellAdminNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.adminPageName,
              path: AppRoutes.adminPagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const AdminHomePage(),
                );
              },
            ),
          ],
        ),

        // tools branch
        StatefulShellBranch(
          navigatorKey: shellToolsNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.toolsPageName,
              path: AppRoutes.toolsPagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const ToolsPage(),
                );
              },
              // sub routes
              routes: [
                // product manage
                GoRoute(
                  name: AppRoutes.productsManagePageName,
                  path: AppRoutes.productsManagePagePath,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const ProductManagePage(),
                    );
                  },
                  routes: [
                    // product add and edit
                    GoRoute(
                      name: AppRoutes.productsAddPageName,
                      path: AppRoutes.productsAddPagePath,
                      builder: (context, state) {
                        final title = state.uri.queryParameters['title'];

                        return ProductAddEditPage(
                          title: title!,
                        );
                      },
                    ),
                  ],
                ),

                // category manage
                GoRoute(
                  name: AppRoutes.categoriesManagePageName,
                  path: AppRoutes.categoriesManagePagePath,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const CategoryManagePage(),
                    );
                  },
                ),

                // users manage
                GoRoute(
                  name: AppRoutes.usersManagePageName,
                  path: AppRoutes.usersManagePagePath,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: const UserManagePage(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // profile branch
        StatefulShellBranch(
          navigatorKey: shellAdminProfileNavigatorKey,
          routes: [
            GoRoute(
              name: AppRoutes.adminProfilePageName,
              path: AppRoutes.adminProfilePagePath,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
