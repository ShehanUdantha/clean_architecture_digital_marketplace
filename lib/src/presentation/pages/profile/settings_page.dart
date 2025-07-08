// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/presentation/blocs/language/language_cubit.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../widgets/profile/settings/language_list_view.dart';
import '../../widgets/profile/settings/settings_card_widget.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/profile/settings/theme_list_view.dart';

class SettingsPage extends StatelessWidget {
  final bool fromAuth;

  const SettingsPage({
    super.key,
    this.fromAuth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                title: context.loc.settings,
                function: () => _handleBackButton(context),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocBuilder<ThemeCubit, ThemeState>(
                buildWhen: (previous, current) =>
                    previous.themeMode != current.themeMode,
                builder: (context, state) {
                  return SettingsCardWidget(
                    title: context.loc.theme,
                    actionWidgetTitle: state.themeName,
                    actionWidgetFunction: () => _showThemeBottomSheet(),
                  );
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocBuilder<LanguageCubit, LanguageState>(
                buildWhen: (previous, current) =>
                    previous.languageLocale != current.languageLocale,
                builder: (context, state) {
                  return SettingsCardWidget(
                    title: context.loc.language,
                    actionWidgetTitle: state.languageName,
                    actionWidgetFunction: () => _showLanguagesBottomSheet(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackButton(BuildContext context) {
    final isUser =
        context.read<AuthBloc>().state.userType == UserTypes.user.name;

    context.goNamed(
      fromAuth
          ? AppRoutes.signInPageName
          : isUser
              ? AppRoutes.profilePageName
              : AppRoutes.adminProfilePageName,
    );
  }

  void _showThemeBottomSheet() {
    Helper.displayBottomSheet(const ThemeListView());
  }

  void _showLanguagesBottomSheet() {
    Helper.displayBottomSheet(const LanguageListView());
  }
}
