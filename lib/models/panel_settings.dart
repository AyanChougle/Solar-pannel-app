// models/panel_settings.dart
class PanelSettings {
  double azimuthAngle; // Direction angle (0-360)
  double tiltAngle; // Tilt angle (0-90)
  String mode; // 'auto' or 'manual'

  PanelSettings({
    this.azimuthAngle = 180.0,
    this.tiltAngle = 30.0,
    this.mode = 'auto',
  });
}
