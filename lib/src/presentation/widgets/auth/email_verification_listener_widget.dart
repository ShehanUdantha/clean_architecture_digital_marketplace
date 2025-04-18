import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';

class EmailVerificationListenerWidget extends StatelessWidget {
  const EmailVerificationListenerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final networkState = context.watch<NetworkBloc>().state;
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.status == BlocStatus.error) {
              Helper.showSnackBar(
                context,
                state.authMessage,
              );
              context.read<SignUpBloc>().add(SetSignUpStatusToDefault());
            }
            if (state.status == BlocStatus.success) {
              Helper.showSnackBar(
                context,
                context.loc.emailVerifySuccess,
              );
              context.read<SignUpBloc>().add(SetSignUpStatusToDefault());
            }
          },
          child: TextButton(
            onPressed: () => _handleEmailVerificationSendButton(
              context,
              networkState,
            ),
            child: Text(
              context.loc.resendEmail,
              style: TextStyle(
                color: isDarkMode ? AppColors.lightGrey : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleEmailVerificationSendButton(
    BuildContext context,
    NetworkState networkState,
  ) {
    if (networkState.networkTypes == NetworkTypes.connected) {
      context.read<SignUpBloc>().add(SendEmailButtonClickedEvent());
    } else {
      Helper.showSnackBar(context, context.loc.noInternetMessage);
    }
  }
}
