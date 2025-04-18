import '../../../core/utils/extension.dart';

import '../../../core/constants/routes_name.dart';
import '../../../core/widgets/linear_loading_indicator.dart';
import '../../blocs/purchase/purchase_bloc.dart';
import '../../widgets/profile/purchase_products_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/page_header_widget.dart';

class PurchaseProductViewPage extends StatefulWidget {
  final List<String> productIds;

  const PurchaseProductViewPage({
    super.key,
    required this.productIds,
  });

  @override
  State<PurchaseProductViewPage> createState() =>
      _PurchaseProductViewPageState();
}

class _PurchaseProductViewPageState extends State<PurchaseProductViewPage> {
  @override
  void initState() {
    context.read<PurchaseBloc>().add(
          GetAllPurchaseItemsByItsProductIds(
            productIds: widget.productIds,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleBackButton(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
          child: Column(
            children: [
              PageHeaderWidget(
                title: context.loc.purchaseProducts,
                function: () => _handleBackButton(context),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocConsumer<PurchaseBloc, PurchaseState>(
                listener: (context, state) {
                  if (state.productStatus == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.productMessage,
                    );
                    context
                        .read<PurchaseBloc>()
                        .add(SetPurchaseProductsStatusToDefault());
                  }

                  if (state.downloadStatus == BlocStatus.error) {
                    Helper.showSnackBar(
                      context,
                      state.downloadMessage,
                    );
                    context
                        .read<PurchaseBloc>()
                        .add(SetPurchaseDownloadStatusToDefault());
                  }

                  if (state.downloadStatus == BlocStatus.success) {
                    Helper.showSnackBar(
                      context,
                      context.loc.productDownloadSuccessful,
                    );
                    context
                        .read<PurchaseBloc>()
                        .add(SetPurchaseDownloadStatusToDefault());
                  }
                },
                builder: (context, state) {
                  switch (state.productStatus) {
                    case BlocStatus.loading:
                      return const LinearLoadingIndicator();
                    case BlocStatus.success:
                      return const PurchaseProductsBuilderWidget();
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

  Future<bool> _handleBackButton(BuildContext context) async {
    context.goNamed(AppRoutes.purchaseHistoryPageName);
    return Future.value(true);
  }
}
