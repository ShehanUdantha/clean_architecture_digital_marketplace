import '../../../domain/usecases/auth/sign_up_params.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/utils/validator.dart';
import '../../../core/widgets/base_icon_button_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
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

    return WillPopScope(
      onWillPop: () async {
        context.goNamed(AppRoutes.signInPageName);
        return Future.value(false);
      },
      child: SafeArea(
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
                      child: BaseIconButtonWidget(
                        function: () => _handleBackButton(),
                      ),
                    ),
                  ],
                ),
                Image(
                  height: Helper.isLandscape(context)
                      ? Helper.screeHeight(context) * 0.3
                      : Helper.screeHeight(context) * 0.12,
                  image: const AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Form(
                  child: Column(
                    children: [
                      InputFieldWidget(
                        controller: _userNameController,
                        hint: 'User Name',
                        prefix: const Icon(Iconsax.user),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputFieldWidget(
                        controller: _emailController,
                        hint: 'Email Address',
                        prefix: const Icon(Iconsax.direct_right),
                        keyBoardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InputFieldWidget(
                        controller: _passwordController,
                        hint: 'Password',
                        prefix: const Icon(Iconsax.password_check),
                        suffix: const Icon(Iconsax.eye),
                        suffixSecondary: const Icon(Iconsax.eye_slash),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                BlocConsumer<SignUpBloc, SignUpState>(
                  listener: (context, state) {
                    if (state.status == BlocStatus.error) {
                      context
                          .read<SignUpBloc>()
                          .add(SetSignUpStatusToDefault());
                      Helper.showSnackBar(
                        context,
                        state.authMessage,
                      );
                    }
                    if (state.status == BlocStatus.success) {
                      context
                          .read<SignUpBloc>()
                          .add(SetSignUpStatusToDefault());
                      context.goNamed(
                        AppRoutes.emailVerificationAndForgotPasswordPageName,
                        queryParameters: {
                          'email': _emailController.text,
                          'page': AuthTypes.signUp.auth,
                          'isForgot': 'false',
                        },
                      );
                      context.read<AuthBloc>().add(RefreshUserEvent());
                    }
                  },
                  builder: (context, state) {
                    if (state.status == BlocStatus.loading) {
                      return const ElevatedLoadingButtonWidget();
                    }
                    return ElevatedButtonWidget(
                      title: const Text('Sign Up'),
                      function: () => _handleSignUp(networkState),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleBackButton() {
    context.goNamed(AppRoutes.signInPageName);
  }

  _handleSignUp(NetworkState networkState) {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);
    String? passwordValidity =
        AppValidator.validatePassword(_passwordController.text);

    if (networkState.networkTypes == NetworkTypes.connected) {
      if (_userNameController.text.isNotEmpty) {
        if (emailValidity == null) {
          if (passwordValidity == null) {
            context.read<SignUpBloc>().add(
                  SignUpButtonClickedEvent(
                    signUpParams: SignUpParams(
                      userName: _userNameController.text,
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
        Helper.showSnackBar(context, AppStrings.requiredUserName);
      }
    } else {
      Helper.showSnackBar(context, AppStrings.noInternetMessage);
    }
  }
}
