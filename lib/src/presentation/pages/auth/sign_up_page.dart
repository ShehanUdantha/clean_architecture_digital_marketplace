import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/assets_paths.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/base_icon_button_widget.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../domain/usecases/auth/sign_up_params.dart';
import '../../blocs/auth/auth_bloc.dart';

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

  Widget _bodyWidget() {
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
          context.goNamed(
            AppRoutes.emailVerificationAndForgotPasswordPageName,
            queryParameters: {
              'email': _emailController.text.trim(),
              'page': AuthTypes.signUp.auth,
              'isForgot': 'false',
            },
          );
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final isLoading = state.status == BlocStatus.loading;

        return PopScope(
          canPop: !isLoading,
          onPopInvokedWithResult: (didPop, result) => {
            if (!didPop && !isLoading) {_handleBackButton()},
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
                            function: () =>
                                isLoading ? () {} : _handleBackButton(),
                          ),
                        ),
                      ],
                    ),
                    Image(
                      height: Helper.isLandscape(context)
                          ? Helper.screeHeight(context) * 0.3
                          : Helper.screeHeight(context) * 0.12,
                      image: const AssetImage(AppAssetsPaths.signUpImage),
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          InputFieldWidget(
                            controller: _userNameController,
                            hint: context.loc.userName,
                            prefix: const Icon(Iconsax.user),
                            isReadOnly: isLoading,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
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
                      height: 32.0,
                    ),
                    ElevatedButtonWidget(
                      title: context.loc.signUp,
                      function: () => _handleSignUp(),
                      isButtonLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleBackButton() {
    context.goNamed(AppRoutes.signInPageName);
  }

  void _handleSignUp() {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);
    String? passwordValidity =
        AppValidator.validatePassword(_passwordController.text);

    if (_userNameController.text.isNotEmpty) {
      if (emailValidity == null) {
        if (passwordValidity == null) {
          context.read<AuthBloc>().add(
                SignUpButtonClickedEvent(
                  signUpParams: SignUpParams(
                    userName: _userNameController.text.trim(),
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
    } else {
      Helper.showSnackBar(context, context.loc.requiredUserName);
    }
  }
}
