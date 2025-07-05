import 'package:Pixelcart/src/presentation/blocs/auth/auth_bloc.dart';
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

class EmailSendPage extends StatefulWidget {
  final String email;
  final String page;
  final bool isForgot;

  const EmailSendPage({
    super.key,
    required this.email,
    required this.page,
    this.isForgot = false,
  });

  @override
  State<EmailSendPage> createState() => _EmailSendPageState();
}

class _EmailSendPageState extends State<EmailSendPage> {
  @override
  void initState() {
    _initEmailSendPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BlocStatus.error) {
          Helper.showSnackBar(
            context,
            state.authMessage,
          );
        }
        if (state.status == BlocStatus.success) {
          Helper.showSnackBar(
            context,
            widget.isForgot
                ? context.loc.forgotPasswordLinkSendSuccess
                : context.loc.emailVerifySuccess,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == BlocStatus.loading;

        return PopScope(
          canPop: !isLoading,
          onPopInvokedWithResult: (didPop, result) => {
            if (!didPop && !isLoading) {_handleBackButton()},
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
                                function: () =>
                                    isLoading ? () {} : _handleBackButton(),
                              ),
                            ),
                          ],
                        ),
                        Image(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 0.8
                              : Helper.screeHeight(context) * 0.4,
                          image: widget.isForgot
                              ? const AssetImage(
                                  AppAssetsPaths.forgotPasswordImage)
                              : const AssetImage(
                                  AppAssetsPaths.emailVerificationImage),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          widget.isForgot
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
                          widget.email,
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
                          widget.isForgot
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
                          function: () =>
                              isLoading ? () {} : _handleContinueButton(),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextButton(
                          onPressed: () => isLoading
                              ? () {}
                              : widget.isForgot
                                  ? _handleResetEmailSendButton()
                                  : _handleEmailVerificationSendButton(),
                          child: Text(
                            context.loc.resendEmail,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.lightGrey
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _initEmailSendPage() {
    if (!widget.isForgot) {
      context.read<AuthBloc>().add(SendEmailButtonClickedEvent());
    }
  }

  void _handleBackButton() {
    if (widget.page == AuthTypes.signIn.auth) {
      context.goNamed(AppRoutes.signInPageName);
    } else if (widget.page == AuthTypes.forgot.auth) {
      context.goNamed(AppRoutes.forgotPasswordPageName);
    } else {
      context.goNamed(AppRoutes.signUpPageName);
    }
  }

  void _handleContinueButton() {
    context.goNamed(AppRoutes.signInPageName);
  }

  void _handleResetEmailSendButton() {
    context
        .read<AuthBloc>()
        .add(SendResetLinkButtonClickedEvent(email: widget.email));
  }

  void _handleEmailVerificationSendButton() {
    context.read<AuthBloc>().add(SendEmailButtonClickedEvent());
  }
}
