import '../../../core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/lists.dart';
import '../../blocs/auth/auth_bloc.dart';

class BasePage extends StatelessWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const BasePage({
    super.key,
    required this.statefulNavigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: statefulNavigationShell,
      bottomNavigationBar: _bottomBarWidget(context),
    );
  }

  Widget _bottomBarWidget(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            previous.userType != current.userType ||
            previous.status != current.status,
        builder: (context, state) {
          final isLoading = state.status == BlocStatus.loading;
          final isUser = state.userType == UserTypes.user.name;

          return BottomNavigationBar(
            items: isUser
                ? AppLists.listOfUserBottomNavigationBarItems(context)
                : AppLists.listOfAdminBottomNavigationBarItems(context),
            currentIndex: statefulNavigationShell.currentIndex,
            onTap: (index) => isLoading ? () {} : _goBranch(index),
            elevation: 0,
          );
        },
      ),
    );
  }

  void _goBranch(int index) {
    statefulNavigationShell.goBranch(
      index,
      initialLocation: index == statefulNavigationShell.currentIndex,
    );
  }
}
