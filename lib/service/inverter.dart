import 'dart:typed_data';

import 'package:modbus/modbus.dart' as modbus;

import '../model/energy_info.dart';

class Inverter {
  Inverter(String ip, {int? port, int? unitID})
      : _client = modbus.createTcpClient(
          ip,
          port: port ?? 502,
          unitId: unitID ?? 3,
          mode: modbus.ModbusMode.rtu,
        );

  final modbus.ModbusClient _client;

  void connect() {
    _client.connect();
  }

  static int _readUint32(Uint16List list, int pos) {
    return (list[pos] << 8) | list[pos + 1];
  }

  Future<EnergyInfo> fetchEnergyInfo() async {
    final gridData = await _client.readHoldingRegisters(30865, 4);
    final gridWIn = _readUint32(gridData, 0);
    final gridWOut = _readUint32(gridData, 2);
    final pvData = await _client.readHoldingRegisters(30775, 2);
    final pvOutput = _readUint32(pvData, 0);
    final gridFeed = gridWOut > 0 ? gridWOut : -gridWIn;
    final homeConsumption = pvOutput - gridFeed;
    return EnergyInfo(
      pvOutput / 1000.0,
      homeConsumption / 1000.0,
      gridFeed / 1000.0,
    );
  }

  void close() {
    _client.close();
  }
}
