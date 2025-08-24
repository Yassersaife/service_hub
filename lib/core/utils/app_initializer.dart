import 'package:flutter/material.dart';
import '../network//network_helper.dart';
import '../../screens/user_type_screen.dart';
import '../../screens/welcome_screen.dart';
import '../../features/customer/screens/customer_bottom_navigation_screen.dart';
import '../../features/service_provider//screens/provider_dashboard_screen.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  Widget _screen = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    _decideInitialScreen();
  }

  Future<void> _decideInitialScreen() async {
    final isFirstTime = await NetworkHelper.isFirstTime();
    final token = await NetworkHelper.getToken();
    final userData = await NetworkHelper.getUserData();

    Widget nextScreen;

    if (isFirstTime) {
      nextScreen = const WelcomeScreen();
      await NetworkHelper.setFirstTime(false);
    } else if (token == null || userData == null) {
      nextScreen = const UserTypeScreen();
    } else {
      final userType = userData['type'];
      if (userType == 'customer') {
        nextScreen = const CustomerBottomNavigationScreen();
      } else {
        nextScreen = const ProviderDashboardScreen();
      }
    }

    if (mounted) {
      setState(() {
        _screen = nextScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _screen;
  }
}
