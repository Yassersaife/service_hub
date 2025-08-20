import 'package:flutter/material.dart';
import 'package:service_hub/features/customer/screens/about_app_screen.dart';
import '../../../utils/app_colors.dart';
import 'customer_home_screen.dart';
import 'customer_services_screen.dart';

class CustomerBottomNavigationScreen extends StatefulWidget {
  const CustomerBottomNavigationScreen({super.key});

  @override
  State<CustomerBottomNavigationScreen> createState() => _CustomerBottomNavigationScreenState();
}

class _CustomerBottomNavigationScreenState extends State<CustomerBottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CustomerHomeScreen(),
    const CustomerServicesScreen(),
    const AboutAppScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.home_outlined,
                    color: _currentIndex == 0 ?  AppColors.primary : Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.home,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.search_outlined,
                    color: _currentIndex == 1 ?  AppColors.primary : Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                label: 'البحث',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.apps_outlined,
                    color: _currentIndex == 2 ?  AppColors.primary : Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.apps,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                label: 'حول التطبيق',
              ),
            ],
          ),
        ),
      ),
    );
  }
}