import 'package:flutester/components/energy_display.dart';
import 'package:flutester/components/energy_flow.dart';
import 'package:flutester/model/energy_info.dart';
import 'package:flutester/service/inverter.dart';
import 'package:flutter/material.dart';

final greenish = Colors.green.shade100;
final redish = Colors.red.shade100;

class HomePage extends StatefulWidget {
  const HomePage(this._inverter, {Key? key}) : super(key: key);

  final Inverter _inverter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Inverter _inverter = widget._inverter;

  @override
  void initState() {
    super.initState();
    _inverter.connect();
  }

  @override
  void dispose() {
    super.dispose();
    _inverter.close();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Center(
          child: StreamBuilder<EnergyInfo>(
              stream:  Stream.periodic(Duration(seconds: 1))
                  .asyncMap((event) => _inverter.fetchEnergyInfo()),
              builder: (context, snapshot) {
                final pv = snapshot.data?.pvOutput ?? 0;
                final home = snapshot.data?.homeConsumption ?? 0;
                final grid = snapshot.data?.gridFeed ?? 0;
                print('pv=${pv}kW home=${home}kW grid=${grid}kW');
                
                Color? _getColor(double val) {
                  if (val > 0) {
                    return greenish;
                  } else if (val < 0) {
                    return redish;
                  }
                }
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EnergyDisplay(
                      label: 'PV-\nErzeugung',
                      icon: Icons.sunny,
                      value: pv,
                      cardColor: _getColor(pv),
                    ),
                    EnergyFlow(FlowDirection.of(pv)),
                    EnergyDisplay(
                      label: 'Gesamt-\nverbrauch',
                      icon: Icons.home,
                      value: home,
                      //cardColor: _getColor(home),
                    ),
                    EnergyFlow(FlowDirection.of(grid)),
                    EnergyDisplay(
                      label: grid >= 0 ? 'Netz-\neinspeisung' : 'Netzbezug',
                      icon: Icons.bolt_sharp,
                      value: grid,
                      cardColor: _getColor(grid),
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }
}
