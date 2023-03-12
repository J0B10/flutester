import 'package:flutter/material.dart';

@immutable
class EnergyInfo {
  const EnergyInfo(this.pvOutput, this.homeConsumption, this.gridFeed);

  final double pvOutput;
  final double homeConsumption;
  final double gridFeed;

  @override
  String toString() => 'pv=${pvOutput}kW'
      ' home=${homeConsumption}kW'
      ' grid=${gridFeed}kW';
}
