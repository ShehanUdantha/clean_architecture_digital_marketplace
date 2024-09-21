import '../../../../core/constants/lists.dart';
import '../../../../core/utils/extension.dart';

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

class UserManagePage extends StatelessWidget {
  const UserManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    final usersState = context.watch<UsersBloc>().state;

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
                  ? Helper.screeHeight(context) * 0.10
                  : Helper.screeHeight(context) * 0.05,
              child: ListView.builder(
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
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            BlocConsumer<UsersBloc, UsersState>(
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const UserListBuilderWidget();
                  case BlocStatus.error:
                    return Center(
                      child: Text(state.message),
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

  _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.toolsPageName);
  }

  _handleUserTypeChipButton(
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
