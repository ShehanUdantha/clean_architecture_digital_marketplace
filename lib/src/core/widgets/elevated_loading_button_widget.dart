import 'package:flutter/material.dart';
import 'circular_loading_indicator.dart';
import 'elevated_button_widget.dart';

class ElevatedLoadingButtonWidget extends StatelessWidget {
  final double radius;

  const ElevatedLoadingButtonWidget({
    super.key,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWidget(
      actionChild: const SizedBox(
        height: 20,
        width: 20,
        child: CircularLoadingIndicator(
          strokeWidth: 2.0,
          isButtonLoading: true,
        ),
      ),
      radius: radius,
    );
  }
}
