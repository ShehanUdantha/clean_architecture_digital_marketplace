import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../../core/widgets/builder_error_message_widget.dart';
import '../../../core/widgets/circular_loading_indicator.dart';
import '../../blocs/user_home/user_home_bloc.dart';
import 'collection_list_builder_widget.dart';

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
        buildWhen: (previous, current) =>
            previous.trendingStatus != current.trendingStatus,
        builder: (context, state) {
          switch (state.trendingStatus) {
            case BlocStatus.loading:
              return const CircularLoadingIndicator();
            case BlocStatus.success:
              return CollectionListBuilderWidget(
                productsList: state.listOfTrending,
              );
            case BlocStatus.error:
              return BuilderErrorMessageWidget(
                message: state.trendingMessage,
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
