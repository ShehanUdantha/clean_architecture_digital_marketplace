import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/utils/validator.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../blocs/forgot_password/forgot_password_bloc.dart';
import '../../blocs/network/network_bloc.dart';

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

  _bodyWidget() {
    final networkState = context.watch<NetworkBloc>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                title: 'Forgot Password',
                function: () => _handleBackButton(),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                AppStrings.forgotPasswordMessage,
                style: TextStyle(
                  color: AppColors.textThird,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                child: Column(
                  children: [
                    InputFieldWidget(
                      controller: _emailController,
                      hint: 'Email Address',
                      prefix: const Icon(Iconsax.direct_right),
                      keyBoardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26.0,
              ),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state.status == BlocStatus.error) {
                    context
                        .read<ForgotPasswordBloc>()
                        .add(SetForgotStatusToDefault());
                    Helper.showSnackBar(
                      context,
                      state.authMessage == ResponseTypes.failure.response
                          ? AppStrings.invalidForgotEmail
                          : state.authMessage,
                    );
                  }
                  if (state.status == BlocStatus.success) {
                    context
                        .read<ForgotPasswordBloc>()
                        .add(SetForgotStatusToDefault());
                    context.goNamed(
                      AppRoutes.emailVerificationAndForgotPasswordPageName,
                      queryParameters: {
                        'email': state.email,
                        'page': AuthTypes.forgot.auth,
                        'isForgot': 'true',
                      },
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == BlocStatus.loading) {
                    return const ElevatedLoadingButtonWidget();
                  }
                  return ElevatedButtonWidget(
                    title: 'Submit',
                    function: () => _handleForgotPassword(networkState),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleBackButton() {
    context.goNamed(AppRoutes.signInPageName);
  }

  _handleForgotPassword(NetworkState networkState) {
    String? emailValidity = AppValidator.validateEmail(_emailController.text);

    if (networkState.networkTypes == NetworkTypes.connected) {
      if (emailValidity == null) {
        context.read<ForgotPasswordBloc>().add(
              SendResetLinkButtonClickedEvent(email: _emailController.text),
            );
      } else {
        Helper.showSnackBar(context, emailValidity);
      }
    } else {
      Helper.showSnackBar(context, AppStrings.noInternetMessage);
    }
  }
}
