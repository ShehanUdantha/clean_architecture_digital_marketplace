import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/base_icon_button_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../widgets/auth/email_verification_listener_widget.dart';
import '../../widgets/auth/forgot_password_listener_widget.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  final String page;
  final bool isForgot;

  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.page,
    this.isForgot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => {
        if (!didPop) {_handleWillPop(context)},
      },
      child: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (context, themeState) {
            final isDarkMode =
                Helper.checkIsDarkMode(context, themeState.themeMode);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: Helper.screeHeight(context) * 0.10,
                        ),
                        Positioned(
                          child: BaseIconButtonWidget(
                            function: () => _handleBackButton(context, page),
                          ),
                        ),
                      ],
                    ),
                    Image(
                      height: Helper.isLandscape(context)
                          ? Helper.screeHeight(context) * 0.8
                          : Helper.screeHeight(context) * 0.4,
                      image: isForgot
                          ? const AssetImage(AppAssetsPaths.forgotPasswordImage)
                          : const AssetImage(
                              AppAssetsPaths.emailVerificationImage),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      isForgot
                          ? context.loc.passwordRestEmailSend
                          : context.loc.emailVerify,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textFifth
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.lightGrey
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      isForgot
                          ? context.loc.forgotPasswordSuccessMessage
                          : context.loc.emailVerifyMessage,
                      style: const TextStyle(
                        color: AppColors.mediumGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    ElevatedButtonWidget(
                      title: context.loc.continues,
                      function: () => _handleContinueButton(context),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    isForgot
                        ? ForgotPasswordListenerWidget(email: email)
                        : const EmailVerificationListenerWidget(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleWillPop(BuildContext context) {
    context.goNamed(AppRoutes.signUpPageName);
  }

  void _handleBackButton(BuildContext context, String page) {
    if (page == AuthTypes.signIn.auth) {
      context.goNamed(AppRoutes.signInPageName);
    }
    if (page == AuthTypes.signUp.auth) {
      context.goNamed(AppRoutes.signUpPageName);
    }
    if (page == AuthTypes.forgot.auth) {
      context.goNamed(AppRoutes.forgotPasswordPageName);
    }
  }

  void _handleContinueButton(BuildContext context) {
    context.goNamed(AppRoutes.signInPageName);
  }
}
