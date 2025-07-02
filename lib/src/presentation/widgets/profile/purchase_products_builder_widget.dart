// ignore_for_file: use_build_context_synchronously

import 'package:Pixelcart/src/core/utils/extension.dart';

import '../../../core/widgets/product_linear_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/helper.dart';
import '../../blocs/purchase/purchase_bloc.dart';

class PurchaseProductsBuilderWidget extends StatelessWidget {
  const PurchaseProductsBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PurchaseBloc, PurchaseState>(
        buildWhen: (previous, current) =>
            previous.listOfPurchaseProducts != current.listOfPurchaseProducts,
        builder: (context, purchaseState) {
          return ListView.builder(
            itemCount: purchaseState.listOfPurchaseProducts.length,
            itemBuilder: (context, index) {
              return ProductLinearCardWidget(
                isAction: false,
                isEdit: false,
                downloadFunction: () => _handleProductDownload(
                  context,
                  purchaseState.listOfPurchaseProducts[index].id!,
                  purchaseState.listOfPurchaseProducts[index].productName,
                ),
                product: purchaseState.listOfPurchaseProducts[index],
              );
            },
          );
        },
      ),
    );
  }

  void _handleProductDownload(
    BuildContext context,
    String productId,
    String productName,
  ) async {
    bool result = await Helper.storagePermissionRequest();
    if (result) {
      context.read<PurchaseBloc>().add(
            ProductDownloadEvent(
              productId: productId,
              productName: productName,
            ),
          );
    } else {
      Helper.showSnackBar(
        context,
        context.loc.noStoragePermission,
      );
    }
  }
}
