// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../../presentation/widgets/settings/settings_card_widget.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../widgets/settings/theme_list_view.dart';

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

  _bodyWidget(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                title: 'Settings',
                function: () => _handleBackButton(context, authState),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return SettingsCardWidget(
                    title: "Theme",
                    actionWidgetTitle: state.themeName,
                    actionWidgetFunction: () => _showThemeBottomSheet(),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SettingsCardWidget(
                title: "Language",
                actionWidgetTitle: "English",
                actionWidgetFunction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleBackButton(BuildContext context, AuthState authState) {
    context.goNamed(
      fromAuth
          ? AppRoutes.signInPageName
          : authState.userType == UserTypes.user.name
              ? AppRoutes.profilePageName
              : AppRoutes.adminProfilePageName,
    );
  }

  _showThemeBottomSheet() {
    Helper.displayBottomSheet(const ThemeListView());
  }
}