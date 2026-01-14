// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/solar_provider.dart';
import '../providers/auth_provider.dart';
import '../models/solar_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final solarProvider = Provider.of<SolarProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentData = solarProvider.currentData;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), elevation: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${authProvider.currentUser?.name ?? "User"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here\'s your solar system overview',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Current Status Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      'Current Generation',
                      '${currentData.powerGeneration.toStringAsFixed(2)} kW',
                      Icons.wb_sunny,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusCard(
                      'Consumption',
                      '${currentData.powerConsumption.toStringAsFixed(2)} kW',
                      Icons.bolt,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      'Net Power',
                      '${currentData.netPower.toStringAsFixed(2)} kW',
                      Icons.analytics,
                      currentData.netPower >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusCard(
                      'Efficiency',
                      '${currentData.efficiency.toStringAsFixed(1)}%',
                      Icons.show_chart,
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Today's Summary
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Total Generation',
                        '${solarProvider.todayGeneration.toStringAsFixed(2)} kWh',
                        Icons.wb_sunny,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Total Consumption',
                        '${solarProvider.todayConsumption.toStringAsFixed(2)} kWh',
                        Icons.bolt,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Net Energy',
                        '${(solarProvider.todayGeneration - solarProvider.todayConsumption).toStringAsFixed(2)} kWh',
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Power Chart
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Power Graph',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildPowerChart(solarProvider.getTodayData()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPowerChart(List<SolarData> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return CustomPaint(painter: PowerChartPainter(data), child: Container());
  }
}

class PowerChartPainter extends CustomPainter {
  final List<SolarData> data;

  PowerChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final consumptionPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final maxPower = data
        .map(
          (d) => d.powerGeneration > d.powerConsumption
              ? d.powerGeneration
              : d.powerConsumption,
        )
        .reduce((a, b) => a > b ? a : b);
    final stepX = size.width / (data.length - 1);

    // Draw generation line
    final generationPath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y =
          size.height - (data[i].powerGeneration / maxPower * size.height);
      if (i == 0) {
        generationPath.moveTo(x, y);
      } else {
        generationPath.lineTo(x, y);
      }
    }
    canvas.drawPath(generationPath, paint);

    // Draw consumption line
    final consumptionPath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y =
          size.height - (data[i].powerConsumption / maxPower * size.height);
      if (i == 0) {
        consumptionPath.moveTo(x, y);
      } else {
        consumptionPath.lineTo(x, y);
      }
    }
    canvas.drawPath(consumptionPath, consumptionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
