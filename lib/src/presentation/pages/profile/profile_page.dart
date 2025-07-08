import 'dart:io';
import 'package:Pixelcart/src/core/widgets/blur_loading_overlay_widget.dart';
import 'package:Pixelcart/src/presentation/blocs/admin_home/admin_home_bloc.dart';
import 'package:Pixelcart/src/presentation/blocs/user_home/user_home_bloc.dart';

import '../../../core/utils/extension.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../widgets/profile/profile_card_widget.dart';

import '../../../core/constants/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bar_title_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../blocs/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == BlocStatus.error) {
            _hideBlurLoading(context);
          }

          if (state.status == BlocStatus.success) {
            _hideBlurLoading(context);
            context.goNamed(AppRoutes.signInPageName);
            context.read<UserHomeBloc>().add(SetUserDetailsToDefault());
            context.read<AdminHomeBloc>().add(SetAdminDetailsToDefault());
            context.read<AuthBloc>().add(SetAuthStatusToDefault());
          }
        },
        buildWhen: (previous, current) =>
            previous.userType != current.userType ||
            previous.status != current.status,
        builder: (context, state) {
          final isLoading = state.status == BlocStatus.loading;
          final isUser = state.userType == UserTypes.user.name;

          return Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppBarTitleWidget(title: context.loc.profile),
                  SizedBox(
                    height: Helper.screeHeight(context) *
                        (Platform.isAndroid ? 0.718 : 0.679),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ProfileCardWidget(
                          title: context.loc.userInformation,
                          function: () => isLoading
                              ? () {}
                              : _moveToPage(
                                  context,
                                  isUser
                                      ? AppRoutes.userInfoPageName
                                      : AppRoutes.adminInfoPageName,
                                ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        if (isUser)
                          ProfileCardWidget(
                            title: context.loc.purchaseHistory,
                            function: () => isLoading
                                ? () {}
                                : _moveToPage(
                                    context,
                                    AppRoutes.purchaseHistoryPageName,
                                  ),
                          ),
                        if (isUser)
                          const SizedBox(
                            height: 16.0,
                          ),
                        ProfileCardWidget(
                          title: context.loc.settings,
                          function: () => isLoading
                              ? () {}
                              : _moveToPage(
                                  context,
                                  isUser
                                      ? AppRoutes.settingsPageName
                                      : AppRoutes.adminSettingsPageName,
                                ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButtonWidget(
                    title: context.loc.signOut,
                    function: () => isLoading ? () {} : _handleSignOut(context),
                    isButtonLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    _showBlurLoading(context);
    context.read<AuthBloc>().add(SignOutEvent());
  }

  void _moveToPage(BuildContext context, String pathName) {
    context.goNamed(pathName);
  }

  void _showBlurLoading(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: 'Loading...',
      barrierColor: Colors.transparent,
      context: context,
      pageBuilder: (_, __, ___) {
        return const BlurLoadingOverlayWidget();
      },
    );
  }

  void _hideBlurLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
