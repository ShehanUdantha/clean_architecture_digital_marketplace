import 'package:Pixelcart/src/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/sign_up/sign_up_bloc.dart';

class EmailVerificationListenerWidget extends StatelessWidget {
  const EmailVerificationListenerWidget({
    super.key,
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
            BlocConsumer<SignUpBloc, SignUpState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
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
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return TextButton(
                  onPressed: () => state.status == BlocStatus.loading
                      ? () {}
                      : _handleEmailVerificationSendButton(context),
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

  void _handleEmailVerificationSendButton(
    BuildContext context,
  ) {
    final networkType = context.read<NetworkBloc>().state.networkTypes;

    if (networkType == NetworkTypes.connected) {
      context.read<SignUpBloc>().add(SendEmailButtonClickedEvent());
    } else {
      Helper.showSnackBar(context, context.loc.noInternetMessage);
    }
  }
}
