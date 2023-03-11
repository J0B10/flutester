import 'dart:async';

import 'package:flutester/components/energy_display.dart';
import 'package:flutester/components/energy_flow.dart';
import 'package:flutester/model/energy_info.dart';
import 'package:flutester/service/inverter.dart';
import 'package:flutter/material.dart';

final greenish = Colors.green.shade100;
final redish = Colors.red.shade100;

const keyDisplayPV = Key('displayPV');
const keyDisplayHome = Key('displayHome');
const keyDisplayGrid = Key('displayGrid');
const keyFlowPV = Key('flowPV');
const keyFlowGrid = Key('flowGrid');

class HomePage extends StatefulWidget {
  const HomePage(this._inverter, this._refreshRate, {super.key});

  final Duration _refreshRate;
  final Inverter _inverter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      builder: (context, constraints) => Scaffold(
            body: Center(
              child: StreamBuilder<EnergyInfo>(
                  stream: Stream.periodic(widget._refreshRate)
                      .asyncMap((event) async => _inverter.fetchEnergyInfo()),
                  builder: (context, snapshot) {
                    var pv = snapshot.data?.pvOutput ?? 0;
                    var home = snapshot.data?.homeConsumption ?? 0;
                    var grid = snapshot.data?.gridFeed ?? 0;
                    debugPrint('pv=${pv}kW home=${home}kW grid=${grid}kW');

                    Color? getColor(double val) {
                      if (val > 0) {
                        return greenish;
                      } else if (val < 0) {
                        return redish;
                      }
                      return null;
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EnergyDisplay(
                          key: keyDisplayPV,
                          label: 'PV-\nErzeugung',
                          icon: Icons.sunny,
                          value: pv,
                          cardColor: getColor(pv),
                        ),
                        EnergyFlow(FlowDirection.of(pv), key: keyFlowPV),
                        EnergyDisplay(
                          key: keyDisplayHome,
                          label: 'Gesamt-\nverbrauch',
                          icon: Icons.home,
                          value: home,
                          //cardColor: _getColor(home),
                        ),
                        EnergyFlow(FlowDirection.of(grid), key: keyFlowGrid),
                        EnergyDisplay(
                          key: keyDisplayGrid,
                          label: grid >= 0 ? 'Netz-\neinspeisung' : 'Netzbezug',
                          icon: Icons.bolt_sharp,
                          value: grid,
                          cardColor: getColor(grid),
                        ),
                      ],
                    );
                  }),
            ),
          ));
}
