import '../../../core/widgets/circular_loading_indicator.dart';
import 'collection_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../core/utils/helper.dart';
import '../../blocs/user_home/user_home_bloc.dart';

class LatestListBuilderWidget extends StatelessWidget {
  const LatestListBuilderWidget({
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
          switch (state.latestStatus) {
            case BlocStatus.loading:
              return const CircularLoadingIndicator();
            case BlocStatus.success:
              return CollectionListBuilderWidget(
                productsList: state.listOfLatest,
              );
            case BlocStatus.error:
              return Center(
                child: Text(state.latestMessage),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
