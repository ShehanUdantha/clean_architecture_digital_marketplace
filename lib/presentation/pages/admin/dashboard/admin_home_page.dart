import '../../../../core/utils/helper.dart';

import '../../../blocs/admin_home/admin_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/main_header_widget.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    initAdminHomePage();
    context.read<AdminHomeBloc>().add(GetAdminDetailsEvent());

    final uid = context.read<AuthBloc>().state.user?.uid ?? "-1";
    context
        .read<NotificationBloc>()
        .add(GetNotificationCountEvent(userId: uid));

    Helper.getNotificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    final adminHomeState = context.watch<AdminHomeBloc>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MainHeaderWidget(
                userName: adminHomeState.userEntity.userName,
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initAdminHomePage() {
    Helper.getNotificationPermission();
  }
}
