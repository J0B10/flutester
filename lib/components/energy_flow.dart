import 'package:flutester/model/flow_direction.dart';
import 'package:flutter/material.dart';

class EnergyFlow extends StatefulWidget {
  const EnergyFlow({
    required this.flow,
    required this.color,
    this.duration = const Duration(seconds: 1),
    this.spacing = 32,
    super.key,
  });

  final Duration duration;
  final FlowDirection flow;
  final double spacing;
  final Color color;

  @override
  State<EnergyFlow> createState() => _EnergyFlowState();
}

class _EnergyFlowState extends State<EnergyFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _animationController.repeat();
      });
  }

  @override
  void didUpdateWidget(covariant EnergyFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.duration = widget.duration;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Animation<double>? get animation {
    switch (widget.flow) {
      case FlowDirection.right:
        return CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInSine,
        );
      case FlowDirection.left:
        return CurvedAnimation(
          parent: ReverseAnimation(_animationController),
          curve: Curves.easeInSine,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.spacing,
        child: widget.flow == FlowDirection.none
            ? null
            : AnimatedBuilder(
                animation: animation!,
                builder: (_, __) => ClipRect(
                  child: CustomPaint(
                    size: Size.square(widget.spacing),
                    painter: _EnergyFlowPainter(
                      animation!.value,
                      widget.color,
                      invertSize: widget.flow == FlowDirection.left,
                    ),
                  ),
                ),
              ),
      );
}

class _EnergyFlowPainter extends CustomPainter {
  const _EnergyFlowPainter(this.state, this.color, {this.invertSize = false})
      : assert(state >= 0 && state <= 1, 'state must be provided in percent');

  final bool invertSize;
  final double state;
  final Color color;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _EnergyFlowPainter) {
      return state != oldDelegate.state;
    }
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 16.0 * (invertSize ? state / 2 + 0.5 : 1 - state / 2);
    var pos =
        Offset((size.width + radius * 2) * state - radius, size.height / 2);
    var paint = Paint()..color = color;
    canvas.drawCircle(pos, radius, paint);
  }
}
