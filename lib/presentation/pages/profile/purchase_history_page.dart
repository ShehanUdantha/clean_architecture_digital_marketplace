import 'package:Pixelcart/core/constants/routes_name.dart';
import 'package:Pixelcart/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/page_header_widget.dart';
import '../../widgets/profile/purchase_items_history_builder_widget.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  @override
  void initState() {
    context.read<PurchaseBloc>().add(GetAllPurchaseHistory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleBackButton(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
          child: Column(
            children: [
              PageHeaderWidget(
                title: 'Purchase History',
                function: () => _handleBackButton(context),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocConsumer<PurchaseBloc, PurchaseState>(
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
                builder: (context, state) {
                  switch (state.status) {
                    case BlocStatus.loading:
                      return const Center(
                        child: LinearProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      );
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
      ),
    );
  }

  _handleBackButton(BuildContext context) {
    context.goNamed(AppRoutes.profilePageName);
  }
}
