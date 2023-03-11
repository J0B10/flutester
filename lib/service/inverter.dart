import 'dart:typed_data';

import 'package:flutester/model/energy_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:modbus/modbus.dart' as modbus;

class Inverter {
  Inverter(String ip, {int? port, int? unitID})
      : _client = modbus.createTcpClient(
          ip,
          port: port ?? 502,
          unitId: unitID ?? 3,
          mode: modbus.ModbusMode.rtu,
        );

  @visibleForTesting
  Inverter.test(this._client);

  final modbus.ModbusClient _client;

  // ignore: discarded_futures
  void connect() => _client.connect();

  @visibleForTesting
  static int readUint32(Uint16List list, int pos) {
    if (list[pos] == 0x8000 && list[pos + 1] == 0x0000) {
      //Inverter returns this value sometimes if no sun is present.
      //Special case or error in the modbus library?
      return 0;
    }
    return (list[pos] << 8) | list[pos + 1];
  }

  Future<EnergyInfo> fetchEnergyInfo() async {
    var gridData = await _client.readHoldingRegisters(30865, 4);
    var gridWIn = readUint32(gridData, 0);
    var gridWOut = readUint32(gridData, 2);
    var pvData = await _client.readHoldingRegisters(30775, 2);
    var pvOutput = readUint32(pvData, 0);
    var gridFeed = gridWOut > 0 ? gridWOut : -gridWIn;
    var homeConsumption = pvOutput - gridFeed;
    return EnergyInfo(
      pvOutput / 1000.0,
      homeConsumption / 1000.0,
      gridFeed / 1000.0,
    );
  }

  // ignore: discarded_futures
  void close() => _client.close();
}
