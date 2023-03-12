// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutester/components/energy_display.dart';
import 'package:flutester/components/energy_flow.dart';
import 'package:flutester/model/energy_info.dart';
import 'package:flutester/model/flow_direction.dart';
import 'package:flutester/pages/home/status.dart';
import 'package:flutester/service/inverter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class InverterMock implements Inverter {
  const InverterMock(this.info);

  final EnergyInfo info;

  @override
  Future<EnergyInfo> fetchEnergyInfo() async => info;

  @override
  void close() {}

  @override
  void connect() {}
}

void main() {
  testWidgets('Test status setup', (tester) async {
    var expected = const EnergyInfo(0, 0, 0);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));

    var pv = tester.widget<EnergyDisplay>(find.byKey(keyDisplayPV));
    expect(pv.value, 0);
    expect(pv.cardColor, null);
    expect(pv.icon, Icons.sunny);
    var home = tester.widget<EnergyDisplay>(find.byKey(keyDisplayHome));
    expect(home.value, 0);
    expect(home.cardColor, null);
    expect(home.icon, Icons.home);
    var grid = tester.widget<EnergyDisplay>(find.byKey(keyDisplayGrid));
    expect(grid.value, 0);
    expect(grid.cardColor, null);
    expect(grid.icon, Icons.bolt_sharp);
    var pvFlow = tester.widget<EnergyFlow>(find.byKey(keyFlowPV));
    expect(pvFlow.flow, FlowDirection.none);
    var gridFlow = tester.widget<EnergyFlow>(find.byKey(keyFlowPV));
    expect(gridFlow.flow, FlowDirection.none);
  });

  testWidgets('Test status display negative balance', (tester) async {
    var expected = const EnergyInfo(3.4, 4.69, -1.29);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));
    await tester.pump(duration);

    var pv = tester.widget<EnergyDisplay>(find.byKey(keyDisplayPV));
    expect(pv.value, 3.4);
    expect(pv.cardColor, greenish);
    var home = tester.widget<EnergyDisplay>(find.byKey(keyDisplayHome));
    expect(home.value, 4.69);
    expect(home.cardColor, null);
    var grid = tester.widget<EnergyDisplay>(find.byKey(keyDisplayGrid));
    expect(grid.value, -1.29);
    expect(grid.cardColor, redish);
    expect(find.textContaining('Netzbezug'), findsOneWidget);
  });

  testWidgets('Test status display positive balance', (tester) async {
    var expected = const EnergyInfo(1.0, 2.71, 1.71);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));
    await tester.pump(duration);

    var pv = tester.widget<EnergyDisplay>(find.byKey(keyDisplayPV));
    expect(pv.value, 1.0);
    expect(pv.cardColor, greenish);
    var home = tester.widget<EnergyDisplay>(find.byKey(keyDisplayHome));
    expect(home.value, 2.71);
    expect(home.cardColor, null);
    var grid = tester.widget<EnergyDisplay>(find.byKey(keyDisplayGrid));
    expect(grid.value, 1.71);
    expect(grid.cardColor, greenish);
    expect(find.textContaining('Netz-\neinspeisung'), findsOneWidget);
  });

  testWidgets('Test status flow positive balance', (tester) async {
    var expected = const EnergyInfo(1.0, 2.71, 1.71);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));
    await tester.pump(duration);

    var pv = tester.widget<EnergyFlow>(find.byKey(keyFlowPV));
    expect(pv.flow, FlowDirection.right);
    var grid = tester.widget<EnergyFlow>(find.byKey(keyFlowGrid));
    expect(grid.flow, FlowDirection.right);
  });

  testWidgets('Test status flow negative balance', (tester) async {
    var expected = const EnergyInfo(3.4, 4.69, -1.29);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));
    await tester.pump(duration);

    var pv = tester.widget<EnergyFlow>(find.byKey(keyFlowPV));
    expect(pv.flow, FlowDirection.right);
    var grid = tester.widget<EnergyFlow>(find.byKey(keyFlowGrid));
    expect(grid.flow, FlowDirection.left);
  });

  testWidgets('Test status no flow', (tester) async {
    var expected = const EnergyInfo(0, 0, 0);
    var duration = const Duration(milliseconds: 5);

    await tester.pumpWidget(MaterialApp(
      home: Status(InverterMock(expected), duration),
    ));
    await tester.pump(duration);

    var pv = tester.widget<EnergyFlow>(find.byKey(keyFlowPV));
    expect(pv.flow, FlowDirection.none);
    var grid = tester.widget<EnergyFlow>(find.byKey(keyFlowGrid));
    expect(grid.flow, FlowDirection.none);
  });
}
