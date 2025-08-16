import 'package:flutter/material.dart';
import 'package:service_hub/features/service_provider/services/provider_service.dart';
import 'screens/welcome_screen.dart';

void main() {
  ProviderService().initializeDummyData();
  runApp(const ProConnectApp());
}

class ProConnectApp extends StatelessWidget {
  const ProConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      home: const WelcomeScreen(),
    );
  }
}