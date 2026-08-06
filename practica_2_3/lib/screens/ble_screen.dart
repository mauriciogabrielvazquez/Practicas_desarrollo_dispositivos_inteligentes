import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos BLE')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth_searching),
              label: const Text('Buscar dispositivos BLE'),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
          if (weatherProvider.bleStatus != "Sin conexion BLE")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                weatherProvider.bleStatus,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: weatherProvider.startBleScan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final results = snapshot.data ?? [];
                  if (results.isEmpty) {
                    return const Center(child: Text('Buscando...'));
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final device = results[index].device;
                      return ListTile(
                        leading: const Icon(Icons.bluetooth),
                        title: Text(device.advName.isEmpty ? 'Desconocido' : device.advName),
                        subtitle: Text(device.remoteId.toString()),
                        onTap: () async {
                          await weatherProvider.connectToWearable(device);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Presiona buscar para iniciar'));
              },
            ),
          ),
        ],
      ),
    );
  }
}