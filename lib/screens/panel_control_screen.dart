// screens/panel_control_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/solar_provider.dart';

class PanelControlScreen extends StatelessWidget {
  const PanelControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final solarProvider = Provider.of<SolarProvider>(context);
    final settings = solarProvider.panelSettings;

    return Scaffold(
      appBar: AppBar(title: const Text('Panel Control'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Solar Panel Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Adjust panel direction and mode',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            // Mode Selection
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
                      'Control Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModeButton(
                            context,
                            'Auto',
                            'Automatic sun tracking',
                            Icons.auto_awesome,
                            settings.mode == 'auto',
                            () {
                              solarProvider.updatePanelSettings(mode: 'auto');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModeButton(
                            context,
                            'Manual',
                            'Custom positioning',
                            Icons.tune,
                            settings.mode == 'manual',
                            () {
                              solarProvider.updatePanelSettings(mode: 'manual');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Azimuth Angle Control
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Azimuth Angle (Direction)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${settings.azimuthAngle.toInt()}°',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'N (0°) → E (90°) → S (180°) → W (270°)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: settings.azimuthAngle,
                      min: 0,
                      max: 360,
                      divisions: 36,
                      label: '${settings.azimuthAngle.toInt()}°',
                      onChanged: settings.mode == 'manual'
                          ? (value) {
                              solarProvider.updatePanelSettings(azimuth: value);
                            }
                          : null,
                    ),
                    if (settings.mode == 'auto')
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Switch to Manual mode to adjust',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tilt Angle Control
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tilt Angle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${settings.tiltAngle.toInt()}°',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Flat (0°) → Vertical (90°)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: settings.tiltAngle,
                      min: 0,
                      max: 90,
                      divisions: 18,
                      label: '${settings.tiltAngle.toInt()}°',
                      onChanged: settings.mode == 'manual'
                          ? (value) {
                              solarProvider.updatePanelSettings(tilt: value);
                            }
                          : null,
                    ),
                    if (settings.mode == 'auto')
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Switch to Manual mode to adjust',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Panel Visualization
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
                      'Panel Orientation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: PanelVisualizationPainter(
                            azimuth: settings.azimuthAngle,
                            tilt: settings.tiltAngle,
                          ),
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange.shade700 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.orange.shade700 : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.orange.shade700
                    : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class PanelVisualizationPainter extends CustomPainter {
  final double azimuth;
  final double tilt;

  PanelVisualizationPainter({required this.azimuth, required this.tilt});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw compass circle
    final compassPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, compassPaint);

    // Draw cardinal directions
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    _drawText(
      canvas,
      'N',
      Offset(center.dx, center.dy - radius - 20),
      textPainter,
    );
    _drawText(
      canvas,
      'E',
      Offset(center.dx + radius + 20, center.dy),
      textPainter,
    );
    _drawText(
      canvas,
      'S',
      Offset(center.dx, center.dy + radius + 20),
      textPainter,
    );
    _drawText(
      canvas,
      'W',
      Offset(center.dx - radius - 20, center.dy),
      textPainter,
    );

    // Draw panel direction arrow
    final arrowPaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    final angle =
        (azimuth - 90) *
        3.14159 /
        180; // Convert to radians, adjust for 0° = North
    final arrowEnd = Offset(
      center.dx + radius * 0.8 * cos(angle),
      center.dy + radius * 0.8 * sin(angle),
    );

    // Draw arrow line
    canvas.drawLine(center, arrowEnd, arrowPaint);

    // Draw arrow head
    final arrowHeadPaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(arrowEnd.dx, arrowEnd.dy);
    path.lineTo(
      arrowEnd.dx - 10 * cos(angle - 0.5),
      arrowEnd.dy - 10 * sin(angle - 0.5),
    );
    path.lineTo(
      arrowEnd.dx - 10 * cos(angle + 0.5),
      arrowEnd.dy - 10 * sin(angle + 0.5),
    );
    path.close();
    canvas.drawPath(path, arrowHeadPaint);

    // Draw tilt indicator
    final tiltY = center.dy + 50;
    final tiltWidth = 60.0;
    final tiltHeight = 4.0;

    canvas.save();
    canvas.translate(center.dx, tiltY);
    canvas.rotate(-tilt * 3.14159 / 180);

    final tiltPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: tiltWidth,
          height: tiltHeight,
        ),
        const Radius.circular(2),
      ),
      tiltPaint,
    );

    canvas.restore();
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    TextPainter textPainter,
  ) {
    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double cos(double radians) {
  return _cos(radians);
}

double sin(double radians) {
  return _sin(radians);
}

// Simple cos approximation
double _cos(double x) {
  x = x % (2 * 3.14159);
  if (x < 0) x += 2 * 3.14159;

  double result = 1.0;
  double term = 1.0;

  for (int i = 1; i <= 10; i++) {
    term *= -x * x / ((2 * i - 1) * (2 * i));
    result += term;
  }

  return result;
}

// Simple sin approximation
double _sin(double x) {
  return _cos(x - 3.14159 / 2);
}
