import '../../../../core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/users/users_bloc.dart';
import 'category_and_user_card_widget.dart';

class UserListBuilderWidget extends StatelessWidget {
  const UserListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<UsersBloc, UsersState>(
        buildWhen: (previous, current) =>
            previous.listOfUsers != current.listOfUsers,
        builder: (context, usersState) {
          if (usersState.listOfUsers.isEmpty) {
            return Center(
              child: Text(context.loc.usersNotAddedYet),
            );
          }

          return ListView.builder(
            itemCount: usersState.listOfUsers.length,
            itemBuilder: (context, index) {
              return CategoryAndUserCardWidget(
                title: usersState.listOfUsers[index].userName,
                type: usersState.listOfUsers[index].userType,
              );
            },
          );
        },
      ),
    );
  }
}
