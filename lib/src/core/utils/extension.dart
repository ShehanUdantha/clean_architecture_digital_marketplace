import 'enum.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension UserTypesExtension on UserTypes {
  String get name => ['admin', 'user'][index];
}

extension AuthTypesExtension on AuthTypes {
  String get auth => ['signIn', 'signUp', 'forgot'][index];
}

extension ProductTypesExtension on ProductStatus {
  String get product => ['active', 'deActive'][index];
}

extension MarketingTypesExtension on MarketingTypes {
  String get types => ['Featured', 'Trending', 'Latest'][index];
}

extension ResponseTypesExtension on ResponseTypes {
  String get response => ['Success', 'Failure'][index];
}

extension BackPageTypesExtension on BackPageTypes {
  String get page => ['home', 'view All'][index];
}

extension CURDTypesExtension on CURDTypes {
  String get curd => ['added', 'removed', 'updated'][index];
}

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
