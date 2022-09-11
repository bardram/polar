import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polar/polar.dart';

void main() => runApp(const PolarExampleApp());

/// Polar Example App.
///
/// Illustrates how to connect and dissconnect to a Polar device, and how to
/// listen to device and heart rate events.
class PolarExampleApp extends StatefulWidget {
  const PolarExampleApp({Key? key}) : super(key: key);

  @override
  State<PolarExampleApp> createState() => _PolarExampleAppState();
}

class _PolarExampleAppState extends State<PolarExampleApp> {
  /// The unique identifier of the Polar device. Normally printed on the edge
  /// of the physical device.
  /// Put your own device id here for testing.
  static const identifier = 'B5FC172F';

  final polar = Polar();
  final logs = [];
  List<DeviceStreamingFeature> features = [];
  StreamSubscription<PolarHeartRateEvent>? hrSubscription;
  StreamSubscription<PolarEcgData>? ecgSubscription;

  @override
  void initState() {
    super.initState();

    polar.batteryLevelStream.listen((e) => log('Battery: ${e.level}'));
    polar.deviceConnectingStream.listen((_) => log('Device connecting'));
    polar.deviceConnectedStream.listen((_) => log(
        'Device connected - Press the Play button to listen to HR events.'));
    polar.deviceDisconnectedStream.listen((_) => log('Device disconnected'));

    polar.streamingFeaturesReadyStream.listen((e) {
      features = e.features;
      log('Device features: $features');
    });
    log('Ready - Press the Bluetooth button to connect to the device with identifier: $identifier');
  }

  void resume() {
    log('Listening to HR');
    hrSubscription =
        polar.heartRateStream.listen((e) => log('Heart rate: ${e.data.hr}'));

    if (features.contains(DeviceStreamingFeature.ecg)) {
      log('Listening to ECG');
      ecgSubscription = polar
          .startEcgStreaming(identifier)
          .listen((e) => log('ECG data: ${e.samples}'));
    }
  }

  void pause() {
    hrSubscription?.cancel();
    ecgSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Polar Demo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bluetooth),
              onPressed: () {
                log('Connecting to device: $identifier');
                polar.connectToDevice(identifier);
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                log('Listening to device: $identifier');
                resume();
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                log('Pausing listening to device: $identifier');
                pause();
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                log('Disconnecting from device: $identifier');
                polar.disconnectFromDevice(identifier);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          children: logs.reversed.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }

  void log(String log) {
    // ignore: avoid_print
    print(log);
    setState(() {
      logs.add(log);
    });
  }
}
