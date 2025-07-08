import '../../../../core/utils/extension.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../widgets/profile/purchase/purchase_items_history_builder_widget.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  @override
  void initState() {
    _initPurchaseHistoryPage();
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
          children: [
            PageHeaderWidget(
              title: context.loc.purchaseHistory,
              function: () => _handleBackButton(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            BlocConsumer<PurchaseBloc, PurchaseState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == BlocStatus.error) {
                  Helper.showSnackBar(
                    context,
                    state.message,
                  );
                  context
                      .read<PurchaseBloc>()
                      .add(SetPurchaseStatusToDefault());
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case BlocStatus.loading:
                    return const LinearLoadingIndicator();
                  case BlocStatus.success:
                    return const PurchaseItemsHistoryBuilder();
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

  void _initPurchaseHistoryPage() {
    context.read<PurchaseBloc>().add(GetAllPurchaseHistory());
  }

  void _handleBackButton() {
    context.goNamed(AppRoutes.profilePageName);
  }
}
