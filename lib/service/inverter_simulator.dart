import 'dart:math';

import 'package:flutester/model/energy_info.dart';
import 'package:flutester/service/inverter.dart';

class InverterSimulator implements Inverter {
  InverterSimulator(this.random);

  final Random random;
  double pv = 0, home = 0;

  @override
  void close() {}

  @override
  void connect() {}

  @override
  Future<EnergyInfo> fetchEnergyInfo() async {
    pv += pow(random.nextDouble() * 2 - 1, 5);
    if (pv < 0) pv = 0;
    if (pv > 9.6) pv = 9.6;
    if (pv > 4.2 && random.nextDouble() < 0.2) pv = random.nextDouble();
    home += pow(random.nextDouble() * 2 - 1, 3);
    if (home < 0) home = random.nextDouble() * 0.5;
    if (home > 4.2) home = 4.2;
    var grid = pv - home;
    return EnergyInfo(pv, home, grid);
  }
}
