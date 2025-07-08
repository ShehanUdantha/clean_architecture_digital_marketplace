import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/main_header_widget.dart';
import '../../../blocs/admin_home/admin_home_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../widgets/admin/dashboard/monthly_status_widget.dart';
import '../../../widgets/admin/dashboard/top_selling_products_widget.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    _initAdminHomePage();
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<AdminHomeBloc, AdminHomeState>(
                buildWhen: (previous, current) =>
                    previous.userEntity != current.userEntity,
                builder: (context, state) {
                  return MainHeaderWidget(
                    userName: state.userEntity.userName,
                  );
                },
              ),
              const SizedBox(
                height: 26.0,
              ),
              const MonthlyStatusWidget(),
              const SizedBox(
                height: 15.0,
              ),
              const TopSellingProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _initAdminHomePage() {
    context.read<AdminHomeBloc>().add(GetAdminDetailsEvent());

    final getCurrentUserId = context.read<AuthBloc>().currentUserId ?? "-1";

    context.read<AdminHomeBloc>().add(GetMonthlyPurchaseStatus());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalance());
    context.read<AdminHomeBloc>().add(GetMonthlyTotalBalancePercentage());
    context.read<AdminHomeBloc>().add(GetMonthlyTopSellingProducts());

    context
        .read<NotificationBloc>()
        .add(GetNotificationCountEvent(userId: getCurrentUserId));

    Helper.getNotificationPermission();
  }
}
