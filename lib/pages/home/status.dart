import 'dart:async';
import 'dart:math';

import 'package:flutester/components/energy_display.dart';
import 'package:flutester/components/energy_flow.dart';
import 'package:flutester/model/energy_info.dart';
import 'package:flutester/model/flow_direction.dart';
import 'package:flutester/service/inverter.dart';
import 'package:flutter/material.dart';

final greenish = Colors.green.shade100;
final redish = Colors.red.shade100;
final accent = Colors.orangeAccent.shade200;

const keyDisplayPV = Key('displayPV');
const keyDisplayHome = Key('displayHome');
const keyDisplayGrid = Key('displayGrid');
const keyFlowPV = Key('flowPV');
const keyFlowGrid = Key('flowGrid');

class Status extends StatefulWidget {
  const Status(this._inverter, this._refreshRate, {super.key});

  final Duration _refreshRate;
  final Inverter _inverter;

  @override
  State<Status> createState() => _StatusState();
}

extension _StatusConstraints on BoxConstraints {
  bool get isLarge => maxWidth > 512 && maxHeight > 264;

  double get energyDisplayWidth {
    if (isLarge) return 128;
    if (maxWidth > 300) return 96;
    return maxWidth / 3;
  }

  double? get energyDisplayHeight {
    if (isLarge) return 256;
    return null;
  }

  double get energyFlowSpacing {
    var maxSpace = (maxWidth - energyDisplayWidth * 3) / 4;
    return min(maxSpace, 128);
  }
}

class _StatusState extends State<Status> {
  late final Inverter _inverter = widget._inverter;

  @override
  void initState() {
    super.initState();
    _inverter.connect();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _inverter.close();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => StreamBuilder<EnergyInfo>(
          stream: Stream.periodic(widget._refreshRate)
              .asyncMap((event) async => _inverter.fetchEnergyInfo()),
          builder: (context, snapshot) {
            var pv = snapshot.data?.pvOutput ?? 0;
            var home = snapshot.data?.homeConsumption ?? 0;
            var grid = snapshot.data?.gridFeed ?? 0;
            debugPrint(snapshot.data?.toString());

            Color? getColor(double val) {
              if (val > 0) return greenish;
              if (val < 0) return redish;
              return null;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EnergyDisplay(
                  width: constraints.energyDisplayWidth,
                  height: constraints.energyDisplayHeight,
                  key: keyDisplayPV,
                  label: 'PV-\nErzeugung',
                  icon: Icons.sunny,
                  value: pv,
                  cardColor: getColor(pv),
                ),
                EnergyFlow(
                  flow: FlowDirection.of(pv),
                  color: accent.withOpacity(0.7),
                  key: keyFlowPV,
                  spacing: constraints.energyFlowSpacing,
                ),
                EnergyDisplay(
                  width: constraints.energyDisplayWidth,
                  height: constraints.energyDisplayHeight,
                  key: keyDisplayHome,
                  label: 'Gesamt-\nverbrauch',
                  icon: Icons.home,
                  value: home,
                  //cardColor: _getColor(home),
                ),
                EnergyFlow(
                  flow: FlowDirection.of(grid),
                  color: accent.withOpacity(0.7),
                  key: keyFlowGrid,
                  spacing: constraints.energyFlowSpacing,
                ),
                EnergyDisplay(
                  width: constraints.energyDisplayWidth,
                  height: constraints.energyDisplayHeight,
                  key: keyDisplayGrid,
                  label: grid >= 0 ? 'Netz-\neinspeisung' : 'Netzbezug',
                  icon: Icons.bolt_sharp,
                  value: grid,
                  cardColor: getColor(grid),
                ),
              ],
            );
          },
        ),
      );
}
