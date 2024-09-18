// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product/purchase_products_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/routes_name.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/theme/theme_bloc.dart';

class PurchaseItemsCardWidget extends StatelessWidget {
  final PurchaseProductsEntity purchaseDetails;

  const PurchaseItemsCardWidget({
    super.key,
    required this.purchaseDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(8.0).copyWith(left: 12.0),
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.3
          : Helper.screeHeight(context) * 0.135,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.lightDark,
          width: 1.3,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Helper.screeWidth(context) * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${purchaseDetails.products.length} Product${purchaseDetails.products.length > 1 ? "s" : ""}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppColors.textFifth
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      Helper.formatDate(purchaseDetails.dateCreated.toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\u{20B9}${double.parse(purchaseDetails.price).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _moveToProductsView(
                  context,
                  purchaseDetails.products,
                ),
                child: const Text(
                  'View Products >',
                  style: TextStyle(
                    color: AppColors.textThird,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _moveToProductsView(BuildContext context, List<String> productsId) {
    context.goNamed(
      AppRoutes.purchaseProductViewPageName,
      extra: productsId,
    );
  }
}
