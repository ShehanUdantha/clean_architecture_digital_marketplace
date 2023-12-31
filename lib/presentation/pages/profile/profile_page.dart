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
import '../../../core/constants/colors.dart';
import '../../blocs/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              const AppBarTitleWidget(title: 'Profile'),
              SizedBox(
                height: Helper.screeHeight(context) * 0.718,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ProfileCardWidget(
                      title: 'User Info',
                      function: () => _moveToPage(
                        context,
                        AppRoutes.profilePageName,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    authState.userType == UserTypes.user.name
                        ? ProfileCardWidget(
                            title: 'Purchase History',
                            function: () => _moveToPage(
                              context,
                              AppRoutes.purchaseHistoryPageName,
                            ),
                          )
                        : const SizedBox(),
                    authState.userType == UserTypes.user.name
                        ? const SizedBox(
                            height: 16,
                          )
                        : const SizedBox(),
                    ProfileCardWidget(
                      title: 'Settings',
                      function: () => _moveToPage(
                        context,
                        AppRoutes.profilePageName,
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
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.white),
                  ),
                  function: () => _handleSignOut(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleSignOut(BuildContext context) {
    context.read<AuthBloc>().add(SignOutEvent());
  }

  _moveToPage(BuildContext context, String pathName) {
    context.goNamed(pathName);
  }
}
