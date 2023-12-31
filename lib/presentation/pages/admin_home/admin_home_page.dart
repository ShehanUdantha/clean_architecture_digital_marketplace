import '../../blocs/admin_home/admin_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/main_header_widget.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    context.read<AdminHomeBloc>().add(GetAdminDetailsEvent());
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
}
