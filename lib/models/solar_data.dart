// models/solar_data.dart
class SolarData {
  final DateTime timestamp;
  final double powerGeneration; // in kW
  final double powerConsumption; // in kW
  final double efficiency; // in percentage

  SolarData({
    required this.timestamp,
    required this.powerGeneration,
    required this.powerConsumption,
    required this.efficiency,
  });

  double get netPower => powerGeneration - powerConsumption;
}
