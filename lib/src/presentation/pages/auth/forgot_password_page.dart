import '../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/utils/validator.dart';
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

  Widget _bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == BlocStatus.error) {
                Helper.showSnackBar(
                  context,
                  state.authMessage,
                );
                context
                    .read<ForgotPasswordBloc>()
                    .add(SetForgotStatusToDefault());
              }
              if (state.status == BlocStatus.success) {
                context.goNamed(
                  AppRoutes.emailVerificationAndForgotPasswordPageName,
                  queryParameters: {
                    'email': state.email,
                    'page': AuthTypes.forgot.auth,
                    'isForgot': 'true',
                  },
                );
                context
                    .read<ForgotPasswordBloc>()
                    .add(SetForgotStatusToDefault());
              }
            },
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeaderWidget(
                    title: context.loc.forgotPassword,
                    function: () => state.status == BlocStatus.loading
                        ? () {}
                        : _handleBackButton(),
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
                    height: 16,
                  ),
                  Form(
                    child: Column(
                      children: [
                        InputFieldWidget(
                          controller: _emailController,
                          hint: context.loc.emailAddress,
                          prefix: const Icon(Iconsax.direct_right),
                          keyBoardType: TextInputType.emailAddress,
                          isReadOnly: state.status == BlocStatus.loading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  state.status == BlocStatus.loading
                      ? const ElevatedLoadingButtonWidget()
                      : ElevatedButtonWidget(
                          title: context.loc.submit,
                          function: () => _handleForgotPassword(),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleBackButton() {
    context.goNamed(AppRoutes.signInPageName);
  }

  void _handleForgotPassword() {
    final networkType = context.read<NetworkBloc>().state.networkTypes;

    String? emailValidity = AppValidator.validateEmail(_emailController.text);

    if (networkType == NetworkTypes.connected) {
      if (emailValidity == null) {
        context.read<ForgotPasswordBloc>().add(
              SendResetLinkButtonClickedEvent(email: _emailController.text),
            );
      } else {
        Helper.showSnackBar(context, emailValidity);
      }
    } else {
      Helper.showSnackBar(context, context.loc.noInternetMessage);
    }
  }
}
