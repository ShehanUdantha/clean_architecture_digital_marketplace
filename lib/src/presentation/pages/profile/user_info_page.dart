import '../../../core/utils/extension.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/utils/enum.dart';
import '../../../core/widgets/input_field_title_widget.dart';
import '../../../core/widgets/input_field_widget.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../blocs/admin_home/admin_home_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _initUserInfoPage();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderWidget(
              title: context.loc.userInformation,
              function: () => _handleBackButton(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InputFieldTitleWidget(
                    title: context.loc.userName,
                  ),
                  InputFieldWidget(
                    controller: _userNameController,
                    hint: context.loc.userName,
                    isReadOnly: true,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  InputFieldTitleWidget(
                    title: context.loc.userEmail,
                  ),
                  InputFieldWidget(
                    controller: _emailController,
                    hint: context.loc.emailAddress,
                    isReadOnly: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initUserInfoPage() {
    final isUser =
        context.read<AuthBloc>().state.userType == UserTypes.user.name;
    final userEntity = isUser
        ? context.read<UserHomeBloc>().state.userEntity
        : context.read<AdminHomeBloc>().state.userEntity;

    _userNameController.text = userEntity.userName;
    _emailController.text = userEntity.email;
  }

  void _handleBackButton() {
    final isUser =
        context.read<AuthBloc>().state.userType == UserTypes.user.name;

    context.goNamed(
      isUser ? AppRoutes.profilePageName : AppRoutes.adminProfilePageName,
    );
  }
}
