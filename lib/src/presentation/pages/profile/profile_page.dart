import 'dart:io';

import '../../../core/utils/extension.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/user_home/user_home_bloc.dart';
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
        listenWhen: (previous, current) =>
            previous.signOutStatus != current.signOutStatus,
        listener: (context, state) {
          if (state.signOutStatus == BlocStatus.success) {
            context.read<UserHomeBloc>().add(SetUserDetailsToDefault());
            context.read<AuthBloc>().add(SetAuthStatusToDefault());
            context.goNamed(AppRoutes.signInPageName);
          }
        },
        buildWhen: (previous, current) =>
            previous.userType != current.userType ||
            previous.signOutStatus != current.signOutStatus,
        builder: (context, authState) {
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
                          function: () =>
                              authState.signOutStatus == BlocStatus.loading
                                  ? () {}
                                  : _moveToPage(
                                      context,
                                      authState.userType == UserTypes.user.name
                                          ? AppRoutes.userInfoPageName
                                          : AppRoutes.adminInfoPageName,
                                    ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (authState.userType == UserTypes.user.name)
                          ProfileCardWidget(
                            title: context.loc.purchaseHistory,
                            function: () =>
                                authState.signOutStatus == BlocStatus.loading
                                    ? () {}
                                    : _moveToPage(
                                        context,
                                        AppRoutes.purchaseHistoryPageName,
                                      ),
                          ),
                        if (authState.userType == UserTypes.user.name)
                          const SizedBox(
                            height: 16,
                          ),
                        ProfileCardWidget(
                          title: context.loc.settings,
                          function: () =>
                              authState.signOutStatus == BlocStatus.loading
                                  ? () {}
                                  : _moveToPage(
                                      context,
                                      authState.userType == UserTypes.user.name
                                          ? AppRoutes.settingsPageName
                                          : AppRoutes.adminSettingsPageName,
                                    ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButtonWidget(
                    title: context.loc.signOut,
                    function: () =>
                        authState.signOutStatus == BlocStatus.loading
                            ? () {}
                            : _handleSignOut(context),
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
    context.read<AuthBloc>().add(SignOutEvent());
  }

  void _moveToPage(BuildContext context, String pathName) {
    context.goNamed(pathName);
  }
}
