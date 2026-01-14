// providers/solar_provider.dart
import 'package:flutter/material.dart';
import '../models/solar_data.dart';
import '../models/panel_settings.dart';
import 'dart:math';

class SolarProvider with ChangeNotifier {
  PanelSettings _panelSettings = PanelSettings();
  List<SolarData> _solarHistory = [];

  SolarProvider() {
    _generateStaticData();
  }

  PanelSettings get panelSettings => _panelSettings;
  List<SolarData> get solarHistory => _solarHistory;

  SolarData get currentData => _solarHistory.isNotEmpty
      ? _solarHistory.last
      : SolarData(
          timestamp: DateTime.now(),
          powerGeneration: 0,
          powerConsumption: 0,
          efficiency: 0,
        );

  double get todayGeneration {
    final today = DateTime.now();
    return _solarHistory
        .where(
          (data) =>
              data.timestamp.year == today.year &&
              data.timestamp.month == today.month &&
              data.timestamp.day == today.day,
        )
        .fold(0.0, (sum, data) => sum + data.powerGeneration);
  }

  double get todayConsumption {
    final today = DateTime.now();
    return _solarHistory
        .where(
          (data) =>
              data.timestamp.year == today.year &&
              data.timestamp.month == today.month &&
              data.timestamp.day == today.day,
        )
        .fold(0.0, (sum, data) => sum + data.powerConsumption);
  }

  void _generateStaticData() {
    final now = DateTime.now();
    final random = Random();

    // Generate last 7 days of data
    for (int day = 6; day >= 0; day--) {
      final date = now.subtract(Duration(days: day));

      // Generate hourly data for each day
      for (int hour = 0; hour < 24; hour++) {
        final timestamp = DateTime(date.year, date.month, date.day, hour);
        double generation = 0;

        // Solar generation pattern (peak at noon)
        if (hour >= 6 && hour <= 18) {
          final peakHour = 12;
          final hourDiff = (hour - peakHour).abs();
          generation = (5.0 - (hourDiff * 0.4)) + random.nextDouble() * 0.5;
          generation = generation.clamp(0, 6.0);
        }

        // Consumption pattern (higher in morning and evening)
        double consumption = 1.5 + random.nextDouble() * 0.5;
        if (hour >= 7 && hour <= 9) consumption += 1.0; // Morning peak
        if (hour >= 18 && hour <= 22) consumption += 1.5; // Evening peak

        final efficiency = generation > 0 ? 75 + random.nextDouble() * 20 : 0.0;

        _solarHistory.add(
          SolarData(
            timestamp: timestamp,
            powerGeneration: generation,
            powerConsumption: consumption,
            efficiency: efficiency,
          ),
        );
      }
    }
  }

  void updatePanelSettings({double? azimuth, double? tilt, String? mode}) {
    if (azimuth != null) _panelSettings.azimuthAngle = azimuth;
    if (tilt != null) _panelSettings.tiltAngle = tilt;
    if (mode != null) _panelSettings.mode = mode;
    notifyListeners();
  }

  List<SolarData> getTodayData() {
    final today = DateTime.now();
    return _solarHistory
        .where(
          (data) =>
              data.timestamp.year == today.year &&
              data.timestamp.month == today.month &&
              data.timestamp.day == today.day,
        )
        .toList();
  }
}
