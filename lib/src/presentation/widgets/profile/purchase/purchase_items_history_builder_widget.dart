import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extension.dart';
import '../../../../core/widgets/item_not_found_text.dart';
import '../../../blocs/purchase/purchase_bloc.dart';
import 'purchase_items_card_widget.dart';

class PurchaseItemsHistoryBuilder extends StatelessWidget {
  const PurchaseItemsHistoryBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PurchaseBloc, PurchaseState>(
        buildWhen: (previous, current) =>
            previous.listOfPurchase != current.listOfPurchase,
        builder: (context, purchaseState) {
          if (purchaseState.listOfPurchase.isEmpty) {
            return ItemNotFoundText(title: context.loc.purchaseNotHappen);
          }

          return ListView.builder(
            itemCount: purchaseState.listOfPurchase.length,
            itemBuilder: (context, index) {
              return PurchaseItemsCardWidget(
                purchaseDetails: purchaseState.listOfPurchase[index],
              );
            },
          );
        },
      ),
    );
  }
}
