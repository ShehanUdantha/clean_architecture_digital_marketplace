import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';

class EmailVerificationListenerWidget extends StatelessWidget {
  const EmailVerificationListenerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final networkState = context.watch<NetworkBloc>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.status == BlocStatus.error) {
              context.read<SignUpBloc>().add(SetSignUpStatusToDefault());
              Helper.showSnackBar(
                context,
                state.authMessage,
              );
            }
            if (state.status == BlocStatus.success) {
              context.read<SignUpBloc>().add(SetSignUpStatusToDefault());
              Helper.showSnackBar(
                context,
                AppStrings.emailVerifySuccess,
              );
            }
          },
          child: TextButton(
            onPressed: () => _handleEmailVerificationSendButton(
              context,
              networkState,
            ),
            child: const Text(
              "Resend Email",
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _handleEmailVerificationSendButton(
    BuildContext context,
    NetworkState networkState,
  ) {
    if (networkState.networkTypes == NetworkTypes.connected) {
      context.read<SignUpBloc>().add(SendEmailButtonClickedEvent());
    } else {
      Helper.showSnackBar(context, AppStrings.noInternetMessage);
    }
  }
}
