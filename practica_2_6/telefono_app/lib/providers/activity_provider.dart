import 'dart:async';
import 'package:flutter/material.dart';
import '../models/activity_data.dart';
import '../services/ble_client.dart';

enum ConnectionStatus { disconnected, scanning, connected, error }

class ActivityProvider extends ChangeNotifier {
  final BleClient _client = BleClient();
  
  ActivityData _data = ActivityData(
    steps: 0, heartRate: 0, calories: 0,
    status: 'sin datos', timestamp: DateTime.now(),
  );
  
  ConnectionStatus _status = ConnectionStatus.disconnected;
  String? _errorMessage;
  StreamSubscription? _dataSub;

  ActivityData get data => _data;
  ConnectionStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _status == ConnectionStatus.connected;

  // =================================================================
  // CÓDIGO ORIGINAL COMENTADO (Descomentar para usar con hardware real)
  // =================================================================
  /*
  Future<void> connect() async {
    _status = ConnectionStatus.scanning;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _client.scanAndConnect();
      _status = ConnectionStatus.connected;
      notifyListeners();
      
      _dataSub = _client.dataStream.listen((data) {
        _data = data;
        notifyListeners();
      });
    } catch (e) {
      _status = ConnectionStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
  */

  // =================================================================
  // BYPASS TEMPORAL PARA TOMAR LAS CAPTURAS DE EVIDENCIA EN EMULADOR
  // =================================================================
  Future<void> connect() async {
    _status = ConnectionStatus.scanning;
    _errorMessage = null;
    notifyListeners();
    
    // 1. Simula el tiempo de búsqueda en la red
    await Future.delayed(const Duration(seconds: 2));
    
    _status = ConnectionStatus.connected;
    notifyListeners();

    int mSteps = 0;
    int mHr = 72;
    double mCal = 0.0;
    String mStatus = 'reposo';
    
    // 2. Inicia la simulación de recepción de datos cada segundo
    _dataSub = Stream.periodic(const Duration(seconds: 1)).listen((_) {
      int time = DateTime.now().second;
      
      // Cambia el estado de la actividad cada 10 segundos
      if (time % 10 == 0) {
        if (mStatus == 'reposo') {
          mStatus = 'caminando';
        } else if (mStatus == 'caminando') {
          mStatus = 'corriendo';
        } else {
          mStatus = 'reposo';
        }
      }
      
      // Incrementa los pasos según la actividad
      if (mStatus == 'caminando') mSteps += 2;
      if (mStatus == 'corriendo') mSteps += 6;
      
      // Dispara el ritmo cardíaco arriba de 120 bpm al correr
      final target = mStatus == 'corriendo' ? 145 : (mStatus == 'caminando' ? 95 : 72);
      mHr = target + (time % 5 - 2); 
      mCal += mSteps * 0.00004;
      
      // Actualiza el modelo y repinta la interfaz
      _data = ActivityData(
        steps: mSteps,
        heartRate: mHr,
        calories: mCal.toInt(),
        status: mStatus,
        timestamp: DateTime.now(),
      );
      notifyListeners();
    });
  }

  Future<void> disconnect() async {
    await _dataSub?.cancel();
    await _client.disconnect();
    _status = ConnectionStatus.disconnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _dataSub?.cancel();
    _client.dispose();
    super.dispose();
  }
}