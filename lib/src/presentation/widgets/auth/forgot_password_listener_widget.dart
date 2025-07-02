// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/forgot_password/forgot_password_bloc.dart';
import '../../blocs/network/network_bloc.dart';

class ForgotPasswordListenerWidget extends StatelessWidget {
  final String email;

  const ForgotPasswordListenerWidget({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, themeState) {
        final isDarkMode =
            Helper.checkIsDarkMode(context, themeState.themeMode);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
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
                  Helper.showSnackBar(
                    context,
                    context.loc.forgotPasswordLinkSendSuccess,
                  );
                  context
                      .read<ForgotPasswordBloc>()
                      .add(SetForgotStatusToDefault());
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return TextButton(
                  onPressed: () => state.status == BlocStatus.loading
                      ? () {}
                      : _handleResetEmailSendButton(
                          context,
                          email,
                        ),
                  child: Text(
                    context.loc.resendEmail,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.lightGrey
                          : AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleResetEmailSendButton(
    BuildContext context,
    String email,
  ) {
    final networkType = context.read<NetworkBloc>().state.networkTypes;

    if (networkType == NetworkTypes.connected) {
      context.read<ForgotPasswordBloc>().add(
            SendResetLinkButtonClickedEvent(email: email),
          );
    } else {
      Helper.showSnackBar(context, context.loc.noInternetMessage);
    }
  }
}
