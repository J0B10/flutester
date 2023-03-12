import 'package:flutester/model/flow_direction.dart';
import 'package:flutter/material.dart';

class EnergyFlow extends StatelessWidget {
  const EnergyFlow(
    this.flow, {
    this.spacing = 32,
    super.key,
  });

  final FlowDirection flow;
  final double spacing;

  IconData? _getFlowIcon() {
    switch (flow) {
      case FlowDirection.right:
        return Icons.arrow_right;
      case FlowDirection.left:
        return Icons.arrow_left;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: spacing,
        child: Center(
          child: Icon(_getFlowIcon()),
        ),
      );
}
