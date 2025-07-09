import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/base_icon_button_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/outline_button_widget.dart';
import '../../../domain/usecases/auth/sign_in_params.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/auth/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return SafeArea(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, themeState) {
          final isDarkMode =
              Helper.checkIsDarkMode(context, themeState.themeMode);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.authMessage,
                    );
                  }
                  if (state.status == BlocStatus.success) {
                    if (state.user?.emailVerified == true) {
                      if (state.userType == UserTypes.admin.name) {
                        context.goNamed(AppRoutes.adminPageName);
                      } else if (state.userType == UserTypes.user.name) {
                        context.goNamed(AppRoutes.homePageName);
                      }
                    } else {
                      context.goNamed(
                        AppRoutes.emailVerificationAndForgotPasswordPageName,
                        queryParameters: {
                          'email': _emailController.text.trim(),
                          'page': AuthTypes.signIn.auth,
                          'isForgot': 'false',
                        },
                      );
                    }
                  }
                },
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  final isLoading = state.status == BlocStatus.loading;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: Helper.screeHeight(context) * 0.15,
                          ),
                          Positioned(
                            right: 0,
                            child: BaseIconButtonWidget(
                              icon: const Icon(
                                Icons.settings,
                                color: AppColors.textFourth,
                              ),
                              function: () => isLoading
                                  ? () {}
                                  : _handleMoveToSettingsPage(),
                            ),
                          ),
                        ],
                      ),
                      Image(
                        height: Helper.isLandscape(context)
                            ? Helper.screeHeight(context) * 0.3
                            : Helper.screeHeight(context) * 0.12,
                        image: const AssetImage(AppAssetsPaths.signInImage),
                      ),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Form(
                        child: Column(
                          children: [
                            InputFieldWidget(
                              controller: _emailController,
                              hint: context.loc.emailAddress,
                              prefix: const Icon(Iconsax.direct_right),
                              keyBoardType: TextInputType.emailAddress,
                              isReadOnly: isLoading,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            InputFieldWidget(
                              controller: _passwordController,
                              hint: context.loc.password,
                              prefix: const Icon(Iconsax.password_check),
                              suffix: const Icon(Iconsax.eye),
                              suffixSecondary: const Icon(Iconsax.eye_slash),
                              isReadOnly: isLoading,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                isLoading ? () {} : _handleMoveToForgotPage(),
                            child: Text(
                              "${context.loc.forgotPassword}?",
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppColors.textFifth
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      ElevatedButtonWidget(
                        title: context.loc.signIn,
                        function: () => _handleSignIn(),
                        isButtonLoading: isLoading,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      OutlineButtonWidget(
                        title: context.loc.signUp,
                        function: () =>
                            isLoading ? () {} : _handleMoveToSignUpPage(),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSignIn() {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);
    String? passwordValidity =
        AppValidator.validatePassword(_passwordController.text);
    if (emailValidity == null) {
      if (passwordValidity == null) {
        context.read<AuthBloc>().add(
              SignInButtonClickedEvent(
                signInParams: SignInParams(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                ),
              ),
            );
      } else {
        Helper.showSnackBar(context, passwordValidity);
      }
    } else {
      Helper.showSnackBar(context, emailValidity);
    }
  }

  void _handleMoveToForgotPage() {
    context.goNamed(AppRoutes.forgotPasswordPageName);
  }

  void _handleMoveToSignUpPage() {
    context.goNamed(AppRoutes.signUpPageName);
  }

  void _handleMoveToSettingsPage() {
    context.goNamed(AppRoutes.authSettingsPageName);
  }
}
