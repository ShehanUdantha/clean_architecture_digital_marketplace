import '../../../core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/lists.dart';
import '../../widgets/base/network_view_widget.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/network/network_bloc.dart';

class BasePage extends StatelessWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const BasePage({
    super.key,
    required this.statefulNavigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context, statefulNavigationShell),
      bottomNavigationBar: _bottomBarWidget(context),
    );
  }

  Widget _bodyWidget(
    BuildContext context,
    StatefulNavigationShell statefulNavigationShell,
  ) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      buildWhen: (previous, current) =>
          previous.networkTypes != current.networkTypes,
      builder: (context, state) {
        if (state.networkTypes == NetworkTypes.notConnected) {
          return const NetworkViewWidget();
        }

        return statefulNavigationShell;
      },
    );
  }

  Widget _bottomBarWidget(BuildContext context) {
    return SafeArea(
      child: BottomNavigationBar(
        items: context.read<AuthBloc>().state.userType == UserTypes.admin.name
            ? AppLists.listOfAdminBottomNavigationBarItems(context)
            : AppLists.listOfUserBottomNavigationBarItems(context),
        currentIndex: statefulNavigationShell.currentIndex,
        onTap: (index) => _goBranch(index),
        elevation: 0,
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
