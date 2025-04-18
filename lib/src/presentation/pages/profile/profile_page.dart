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
    final authState = context.watch<AuthBloc>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBarTitleWidget(title: context.loc.profile),
              SizedBox(
                height: Helper.screeHeight(context) * 0.718,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ProfileCardWidget(
                      title: context.loc.userInformation,
                      function: () => _moveToPage(
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
                        function: () => _moveToPage(
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
                      function: () => _moveToPage(
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
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.signOutStatus == BlocStatus.success) {
                    context.read<UserHomeBloc>().add(SetUserDetailsToDefault());
                    context.read<AuthBloc>().add(SetAuthStatusToDefault());
                    context.goNamed(AppRoutes.signInPageName);
                  }
                },
                child: ElevatedButtonWidget(
                  title: context.loc.signOut,
                  function: () => _handleSignOut(context),
                ),
              ),
            ],
          ),
        ),
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
