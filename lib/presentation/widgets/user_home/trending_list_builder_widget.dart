import '../../../core/utils/enum.dart';
import 'collection_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/user_home/user_home_bloc.dart';

class TrendingListBuilderWidget extends StatelessWidget {
  const TrendingListBuilderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Helper.isLandscape(context)
          ? Helper.screeHeight(context) * 0.75
          : Helper.screeHeight(context) * 0.355,
      child: BlocBuilder<UserHomeBloc, UserHomeState>(
        builder: (context, state) {
          switch (state.trendingStatus) {
            case BlocStatus.loading:
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                ),
              );
            case BlocStatus.success:
              return CollectionListBuilderWidget(
                productsList: state.listOfTrending,
              );
            case BlocStatus.error:
              return Center(
                child: Text(state.trendingMessage),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
