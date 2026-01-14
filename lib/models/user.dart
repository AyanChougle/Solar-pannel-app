// models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String location;
  final int panelCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.panelCount,
  });
}
