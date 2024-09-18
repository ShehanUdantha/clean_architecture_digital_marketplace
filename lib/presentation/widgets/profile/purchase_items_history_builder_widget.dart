import '../../../core/widgets/item_not_found_text.dart';
import '../../blocs/purchase/purchase_bloc.dart';
import 'purchase_items_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/strings.dart';

class PurchaseItemsHistoryBuilder extends StatelessWidget {
  const PurchaseItemsHistoryBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final purchaseState = context.watch<PurchaseBloc>().state;

    return Expanded(
      child: purchaseState.listOfPurchase.isNotEmpty
          ? ListView.builder(
              itemCount: purchaseState.listOfPurchase.length,
              itemBuilder: (context, index) {
                return PurchaseItemsCardWidget(
                  purchaseDetails: purchaseState.listOfPurchase[index],
                );
              },
            )
          : const ItemNotFoundText(title: AppStrings.purchaseNotHappen),
    );
  }
}
