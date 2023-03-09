import 'package:flutter/material.dart';

class EnergyDisplay extends StatelessWidget {
  const EnergyDisplay({
    Key? key,
    required this.label,
    required this.icon,
    required this.value,
    this.cardColor,
    this.width = 96,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final double width;
  final double value;
  final Color? cardColor;

  Color? _textColor(ThemeData theme) {
    if (cardColor == null) {
      return null;
    } else if (cardColor!.computeLuminance() > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _textColor(theme);
    final valueStyle = theme.textTheme.displaySmall!.copyWith(color: color);
    final textStyle = theme.textTheme.bodyMedium!.copyWith(color: color);

    return Card(
      color: cardColor,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 72,
              ),
              const SizedBox(width: 8),
              Text(
                '$label\n',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  value.toStringAsFixed(2),
                  style: valueStyle,
                ),
              ),
              Text('kW', style: textStyle)
            ],
          ),
        ),
      ),
    );
  }
}
