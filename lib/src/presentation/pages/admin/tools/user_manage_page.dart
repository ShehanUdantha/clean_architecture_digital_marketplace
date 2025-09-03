import 'dart:io';

import '../../../../core/constants/lists.dart';
import '../../../../core/utils/extension.dart';

import '../../../../core/widgets/builder_error_message_widget.dart';
import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../widgets/admin/tools/user_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/page_header_widget.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../blocs/users/users_bloc.dart';
import '../../../widgets/admin/tools/user_type_chip_widget.dart';

class UserManagePage extends StatefulWidget {
  const UserManagePage({super.key});

  @override
  State<UserManagePage> createState() => _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  @override
  void initState() {
    _initUserManagePage();
    super.initState();
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
              title: context.loc.manageUsers,
              function: () => _handleBackButton(context),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: Helper.isLandscape(context)
                  ? Helper.screeHeight(context) *
                      (Platform.isAndroid ? 0.10 : 0.09)
                  : Helper.screeHeight(context) *
                      (Platform.isAndroid ? 0.05 : 0.042),
              child: BlocBuilder<UsersBloc, UsersState>(
                buildWhen: (previous, current) =>
                    previous.currentUserType != current.currentUserType,
                builder: (context, usersState) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemCount: AppLists.listOfUserType.length,
                    itemBuilder: (context, index) {
                      final userTypeName = AppLists.listOfUserType[index];

                      return GestureDetector(
                        onTap: () => _handleUserTypeChipButton(
                          context,
                          index,
                          userTypeName,
                        ),
                        child: UserTypeChipWidget(
                          index: index,
                          pickedValue: usersState.currentUserType,
                          userTypeName: userTypeName,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            BlocConsumer<UsersBloc, UsersState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const UserListBuilderWidget();
                  case BlocStatus.error:
                    return BuilderErrorMessageWidget(
                      message: state.message,
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initUserManagePage() {
    context.read<UsersBloc>().add(GetAllUsersEvent());
  }

  void _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.toolsPageName);
  }

  void _handleUserTypeChipButton(
    BuildContext context,
    int index,
    String userTypeName,
  ) {
    context.read<UsersBloc>().add(
          UserTypeSelectEvent(
            value: index,
            name: userTypeName,
          ),
        );

    context.read<UsersBloc>().add(
          GetAllUsersEvent(),
        );
  }
}
