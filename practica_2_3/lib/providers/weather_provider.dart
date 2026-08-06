import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/weather_model.dart';
import '../services/ble_service.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  int _tempUnit = 0; 

  // Variables para BLE
  final BLEService _bleService = BLEService();
  BluetoothDevice? connectedDevice;
  bool isBleConnected = false;
  String bleStatus = "Sin conexion BLE";

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get temperatureUnit => _tempUnit == 0 ? '°C' : '°F';

  Future<void> loadWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _weather = Weather(
        city: city,
        temperature: 24,
        condition: 'cloudy',
        humidity: 65,
      );
    } catch (e) {
      _errorMessage = 'Error loading weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleTemperatureUnit() {
    _tempUnit = _tempUnit == 0 ? 1 : 0;
    notifyListeners();
  }

  Stream<List<ScanResult>> startBleScan() {
    return _bleService.scanForDevices();
  }

  Future<void> connectToWearable(BluetoothDevice device) async {
    bleStatus = "Conectando...";
    notifyListeners();

    try {
      await _bleService.connect(device);
      connectedDevice = device;
      isBleConnected = true;
      bleStatus = "Conectado a ${device.advName}";
      
      device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          handleBleDisconnection();
        }
      });
    } catch (e) {
      bleStatus = "Error de conexión BLE";
    } finally {
      _bleService.stopScan();
      notifyListeners();
    }
  }

  void handleBleDisconnection() {
    isBleConnected = false;
    connectedDevice = null;
    bleStatus = "Sin conexion BLE";
    notifyListeners();
  }
}