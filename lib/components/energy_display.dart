import 'package:flutter/material.dart';

class EnergyDisplay extends StatelessWidget {
  const EnergyDisplay({
    required this.label,
    required this.icon,
    required this.value,
    this.cardColor,
    this.width,
    this.height,
    super.key,
  });

  final String label;
  final IconData icon;
  final double? width;
  final double? height;
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
    var theme = Theme.of(context);
    var color = _textColor(theme);
    var valueStyle = theme.textTheme.displaySmall!.copyWith(color: color);
    var textStyle = theme.textTheme.bodyMedium!.copyWith(color: color);

    return Card(
      color: cardColor,
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
