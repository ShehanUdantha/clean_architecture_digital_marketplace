import '../../../../domain/entities/cart/purchase_entity.dart';

import '../../../../core/utils/extension.dart';

import '../../../../core/constants/routes_name.dart';
import '../../../../core/widgets/builder_error_message_widget.dart';
import '../../../../core/widgets/linear_loading_indicator.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import '../../../widgets/profile/purchase/purchase_products_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/enum.dart';
import '../../../../core/widgets/page_header_widget.dart';

class PurchaseProductViewPage extends StatefulWidget {
  final PurchaseEntity purchaseDetails;

  const PurchaseProductViewPage({
    super.key,
    required this.purchaseDetails,
  });

  @override
  State<PurchaseProductViewPage> createState() =>
      _PurchaseProductViewPageState();
}

class _PurchaseProductViewPageState extends State<PurchaseProductViewPage> {
  @override
  void initState() {
    _initPurchaseProductViewPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => {
        if (!didPop) {_handleBackButton()},
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
          child: Column(
            children: [
              PageHeaderWidget(
                title: context.loc.purchaseProducts,
                function: () => _handleBackButton(),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocBuilder<PurchaseBloc, PurchaseState>(
                buildWhen: (previous, current) =>
                    previous.productStatus != current.productStatus,
                builder: (context, state) {
                  switch (state.productStatus) {
                    case BlocStatus.loading:
                      return const LinearLoadingIndicator();
                    case BlocStatus.success:
                      return const PurchaseProductsBuilderWidget();
                    case BlocStatus.error:
                      return BuilderErrorMessageWidget(
                        message: state.message,
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

  void _initPurchaseProductViewPage() {
    context.read<PurchaseBloc>().add(
          GetAllPurchaseItemsByItsProductIds(
            purchaseDetails: widget.purchaseDetails,
          ),
        );
  }

  void _handleBackButton() {
    context.goNamed(AppRoutes.purchaseHistoryPageName);
  }
}
