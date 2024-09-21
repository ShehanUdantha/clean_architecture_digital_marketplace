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
import '../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/outline_button_widget.dart';
import '../../../domain/usecases/auth/sign_in_params.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/sign_in/sign_in_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';

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

  _bodyWidget() {
    final networkState = context.watch<NetworkBloc>().state;
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
                      function: () => _handleMoveToSettingsPage(),
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
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFieldWidget(
                      controller: _passwordController,
                      hint: context.loc.password,
                      prefix: const Icon(Iconsax.password_check),
                      suffix: const Icon(Iconsax.eye),
                      suffixSecondary: const Icon(Iconsax.eye_slash),
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
                    onPressed: () => _handleMoveToForgotPage(),
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
              BlocConsumer<SignInBloc, SignInState>(
                listener: (context, state) {
                  if (state.status == BlocStatus.error) {
                    context.read<SignInBloc>().add(SetSignInStatusToDefault());
                    Helper.showSnackBar(
                      context,
                      state.authMessage,
                    );
                  }
                  if (state.status == BlocStatus.success) {
                    if (state.isVerify) {
                      if (state.userType == UserTypes.admin.name) {
                        context.goNamed(AppRoutes.adminPageName);
                        context
                            .read<SignInBloc>()
                            .add(SetSignInStatusToDefault());
                      }
                      if (state.userType == UserTypes.user.name) {
                        context.goNamed(AppRoutes.homePageName);
                        context
                            .read<SignInBloc>()
                            .add(SetSignInStatusToDefault());
                      }
                    } else {
                      context
                          .read<SignInBloc>()
                          .add(SetSignInStatusToDefault());
                      context.goNamed(
                        AppRoutes.emailVerificationAndForgotPasswordPageName,
                        queryParameters: {
                          'email': state.signInParams.email,
                          'page': AuthTypes.signIn.auth,
                          'isForgot': 'false',
                        },
                      );
                      context.read<AuthBloc>().add(RefreshUserEvent());
                    }
                  }
                },
                builder: (context, state) {
                  if (state.status == BlocStatus.loading) {
                    return const ElevatedLoadingButtonWidget();
                  }
                  return ElevatedButtonWidget(
                    title: context.loc.signIn,
                    function: () => _handleSignIn(networkState),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              OutlineButtonWidget(
                title: context.loc.signUp,
                function: () => _handleMoveToSignUpPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleSignIn(NetworkState networkState) {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);
    String? passwordValidity =
        AppValidator.validatePassword(_passwordController.text);
    if (networkState.networkTypes == NetworkTypes.connected) {
      if (emailValidity == null) {
        if (passwordValidity == null) {
          context.read<SignInBloc>().add(
                SignInButtonClickedEvent(
                  signInParams: SignInParams(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                ),
              );
        } else {
          Helper.showSnackBar(context, passwordValidity);
        }
      } else {
        Helper.showSnackBar(context, emailValidity);
      }
    } else {
      Helper.showSnackBar(context, context.loc.noInternetMessage);
    }
  }

  _handleMoveToForgotPage() {
    context.goNamed(AppRoutes.forgotPasswordPageName);
  }

  _handleMoveToSignUpPage() {
    context.goNamed(AppRoutes.signUpPageName);
  }

  _handleMoveToSettingsPage() {
    context.goNamed(AppRoutes.authSettingsPageName);
  }
}
