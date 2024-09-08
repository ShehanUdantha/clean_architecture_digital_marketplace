import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../blocs/admin_tools/users/users_bloc.dart';
import 'category_and_user_card_widget.dart';

class UserListBuilderWidget extends StatelessWidget {
  const UserListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final usersState = context.watch<UsersBloc>().state;

    return Expanded(
      child: usersState.listOfUsers.isNotEmpty
          ? ListView.builder(
              itemCount: usersState.listOfUsers.length,
              itemBuilder: (context, index) {
                return CategoryAndUserCardWidget(
                  title: usersState.listOfUsers[index].userName,
                  type: usersState.listOfUsers[index].userType,
                );
              },
            )
          : const Center(
              child: Text(AppStrings.usersNotAddedYet),
            ),
    );
  }
}
