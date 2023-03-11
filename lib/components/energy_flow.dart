import 'package:flutter/material.dart';

enum FlowDirection {
  left,
  right,
  none;

  FlowDirection invert() {
    switch (this) {
      case FlowDirection.left:
        return FlowDirection.right;
      case FlowDirection.right:
        return FlowDirection.left;
      default:
        return FlowDirection.none;
    }
  }

  static FlowDirection of(double val) {
    if (val > 0) {
      return FlowDirection.right;
    } else if (val < 0) {
      return FlowDirection.left;
    } else {
      return FlowDirection.none;
    }
  }
}

class EnergyFlow extends StatelessWidget {
  const EnergyFlow(
    this.flow, {
    this.spacing = 32.0,
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
