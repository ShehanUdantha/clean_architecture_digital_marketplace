import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/validator.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../blocs/auth/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
              'page': AuthTypes.forgot.auth,
              'isForgot': 'true',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeaderWidget(
                      title: context.loc.forgotPassword,
                      function: () => isLoading ? () {} : _handleBackButton(),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      context.loc.forgotPasswordMessage,
                      style: const TextStyle(
                        color: AppColors.textThird,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    ElevatedButtonWidget(
                      title: context.loc.submit,
                      function: () => _handleForgotPassword(),
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

  void _handleForgotPassword() {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);

    if (emailValidity == null) {
      context.read<AuthBloc>().add(
            SendResetLinkButtonClickedEvent(
              email: _emailController.text.trim(),
            ),
          );
    } else {
      Helper.showSnackBar(context, emailValidity);
    }
  }
}
