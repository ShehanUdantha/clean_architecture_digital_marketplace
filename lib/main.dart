import 'l10n/generated/app_localizations.dart';
import 'src/presentation/blocs/language/language_cubit.dart';
import 'src/presentation/blocs/theme/theme_cubit.dart';

import 'src/core/services/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'src/config/routes/router.dart';
import 'src/config/theme/theme.dart';
import 'src/core/services/notification_service.dart';
import 'src/core/services/service_locator.dart' as locator;
import 'firebase_options.dart';
import 'src/presentation/blocs/admin_home/admin_home_bloc.dart';
import 'src/presentation/blocs/category/category_bloc.dart';
import 'src/presentation/blocs/notification/notification_bloc.dart';
import 'src/presentation/blocs/product/product_bloc.dart';
import 'src/presentation/blocs/users/users_bloc.dart';
import 'src/presentation/blocs/auth/auth_bloc.dart';
import 'src/presentation/blocs/cart/cart_bloc.dart';
import 'src/presentation/blocs/product_details/product_details_bloc.dart';
import 'src/presentation/blocs/purchase/purchase_bloc.dart';
import 'src/presentation/blocs/stripe/stripe_bloc.dart';
import 'src/presentation/blocs/user_home/user_home_bloc.dart';

void main() async {
  // initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize hive db
  final appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);

  // initialize firebase crashlytics
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // initialize dependency injection
  await locator.serviceLocator();

  // initialize stripe publishable key
  Stripe.publishableKey = Env.stripeTestPublishableKey;
  await Stripe.instance.applySettings();

  // initialize notification
  locator.sl<NotificationService>().initLocalNotification();
  locator.sl<NotificationService>().initFirebaseMessagingListeners();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<AdminHomeBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<CategoryBloc>()..add(GetAllCategoriesEvent()),
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<ProductBloc>()..add(GetAllProductsEvent()),
        ),
        BlocProvider(
          create: (context) => locator.sl<UsersBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<UserHomeBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<ProductDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<CartBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<StripeBloc>(),
        ),
        BlocProvider(
          create: (context) => locator.sl<PurchaseBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              locator.sl<NotificationBloc>()..add(GetAllNotificationsEvent()),
        ),
        BlocProvider(
          create: (context) => locator.sl<ThemeCubit>()..init(),
        ),
        BlocProvider(
          create: (context) => locator.sl<LanguageCubit>()..init(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            buildWhen: (previous, current) =>
                previous.languageLocale != current.languageLocale,
            builder: (context, languageState) {
              return MaterialApp.router(
                title: 'Pixelcart',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: languageState.languageLocale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: goRouter,
              );
            },
          );
        },
      ),
    );
  }
}
