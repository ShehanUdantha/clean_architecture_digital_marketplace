import '../../../core/utils/extension.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/input_field_title_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../blocs/admin_home/admin_home_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userEntity = authState.userType == UserTypes.user.name
        ? context.watch<UserHomeBloc>().state.userEntity
        : context.watch<AdminHomeBloc>().state.userEntity;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeaderWidget(
                title: context.loc.userInformation,
                function: () => _handleBackButton(context, authState),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: Helper.screeHeight(context) * 0.718,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InputFieldTitleWidget(
                      title: context.loc.userName,
                    ),
                    InputFieldWidget(
                      hint: userEntity.userName,
                      isReadOnly: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InputFieldTitleWidget(
                      title: context.loc.userEmail,
                    ),
                    InputFieldWidget(
                      hint: userEntity.email,
                      isReadOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackButton(BuildContext context, AuthState authState) {
    context.goNamed(
      authState.userType == UserTypes.user.name
          ? AppRoutes.profilePageName
          : AppRoutes.adminProfilePageName,
    );
    FocusScope.of(context).unfocus();
  }
}
