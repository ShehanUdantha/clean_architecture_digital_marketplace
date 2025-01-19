import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/lists.dart';
import '../../../../core/utils/helper.dart';
import '../../../blocs/admin_home/admin_home_bloc.dart';
import '../../../blocs/theme/theme_bloc.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return BlocBuilder<AdminHomeBloc, AdminHomeState>(
      builder: (context, state) {
        List<FlSpot> spots = generateSpots(state.monthlyStatus);
        return SizedBox(
          child: AspectRatio(
            aspectRatio: 9 / 4,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (LineBarSpot spot) {
                      return AppColors.lightGrey;
                    },
                  ),
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => bottomTileWidget(
                        value,
                        meta,
                        context,
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: leftTileWidget,
                      showTitles: true,
                      interval: 1,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: isDarkMode ? AppColors.primary : AppColors.secondary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.grey,
                          Colors.transparent,
                        ],
                      ),
                      show: true,
                    ),
                    dotData: const FlDotData(show: false),
                    spots: spots,
                  ),
                ],
                minX: 0,
                maxX: 120,
                maxY: 105,
                minY: -5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomTileWidget(double value, TitleMeta meta, BuildContext context) {
    final item =
        AppLists.monthlyPurchaseStatusChartBottomTitles(context)[value.toInt()];
    return item != null
        ? SideTitleWidget(
            meta: meta,
            space: 10,
            child: Text(
              item.toString(),
              style: const TextStyle(fontSize: 9, color: AppColors.mediumGrey),
            ),
          )
        : const SizedBox();
  }

  Widget leftTileWidget(double value, TitleMeta meta) {
    final item = AppLists.monthlyPurchaseStatusChartLeftTitles[value.toInt()];
    return item != null
        ? Text(
            item.toString(),
            style: const TextStyle(fontSize: 9, color: AppColors.mediumGrey),
          )
        : const SizedBox();
  }

  List<FlSpot> generateSpots(Map<String, int> data) {
    Map<int, int> weekCounts = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
    };

    data.forEach((key, value) {
      int day = int.parse(key);
      int week = Helper.getWeekFromDay(day);

      if (weekCounts.containsKey(week)) {
        weekCounts[week] = weekCounts[week]! + value;
      }
    });

    List<FlSpot> spots = [];
    for (int week = 1; week <= 5; week++) {
      // use week number * 20 for the x axis value and product count for the y axis value
      spots.add(
        FlSpot((week * 20).toDouble(), weekCounts[week]?.toDouble() ?? 0),
      );
    }

    return spots;
  }
}
