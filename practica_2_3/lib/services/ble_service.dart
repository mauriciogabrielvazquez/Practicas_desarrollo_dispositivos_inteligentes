import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  Stream<List<ScanResult>> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    return FlutterBluePlus.scanResults;
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    await device.connect();
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }
  bool _validateData(String city, int temp) {
    if (city.length >= 50) return false;
    if (temp < -60 || temp > 60) return false;
    return true;
  }

  Future<Map<String, dynamic>?> readCharacteristic(BluetoothDevice device, String serviceUuid, String characteristicUuid) async {
    List<BluetoothService> services = await device.discoverServices();
    
    for (BluetoothService service in services) {
      if (service.uuid.toString() == serviceUuid) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUuid) {
            
            List<int> value = await characteristic.read();
            String decodedData = utf8.decode(value);
            
            try {
              final data = jsonDecode(decodedData);
              final city = data['city'] as String;
              final temp = data['temp'] as int;

              if (_validateData(city, temp)) {
                return data;
              } else {
                throw Exception("Datos BLE inválidos o fuera de rango");
              }
            } catch (e) {
              return null;
            }
          }
        }
      }
    }
    return null;
  }
}