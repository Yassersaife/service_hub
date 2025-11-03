import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Lumixy/core/utils/app_initializer.dart';
import 'package:Lumixy/features/auth/services/auth_service.dart';
import 'features/customer/screens/customer_bottom_navigation_screen.dart';
import 'features/customer/screens/customer_services_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.loadSavedData();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const ProConnectApp());
}

class ProConnectApp extends StatelessWidget {
  const ProConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'Lumixy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor:AppColors.primary,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
        ),
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AppInitializer(),
        routes: {
          '/customer': (context) => const CustomerBottomNavigationScreen(),
          '/search': (context) => const CustomerServicesScreen(),
        },
      ),
    );
  }
}