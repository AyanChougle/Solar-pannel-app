// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/panel_control_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/solar_provider.dart';
import 'providers/maintenance_provider.dart';

void main() {
  runApp(const SolarPanelApp());
}

class SolarPanelApp extends StatelessWidget {
  const SolarPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SolarProvider()),
        ChangeNotifierProvider(create: (_) => MaintenanceProvider()),
      ],
      child: MaterialApp(
        title: 'Solar Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAuthenticated
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/panel-control': (context) => const PanelControlScreen(),
          '/maintenance': (context) => const MaintenanceScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
