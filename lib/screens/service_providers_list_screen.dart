import 'package:flutter/material.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/service_provider_card.dart';
import 'service_provider_form_screen.dart';
import 'user_type_screen.dart';

class ServiceProvidersListScreen extends StatefulWidget {
  final ServiceProvider? newProvider;

  const ServiceProvidersListScreen({super.key, this.newProvider});

  @override
  State<ServiceProvidersListScreen> createState() => _ServiceProvidersListScreenState();
}

class _ServiceProvidersListScreenState extends State<ServiceProvidersListScreen> {
  List<ServiceProvider> providers = [];

  @override
  void initState() {
    super.initState();
    if (widget.newProvider != null) {
      providers.add(widget.newProvider!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            const Text(
              'مقدمو الخدمات',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${providers.length} مقدم خدمة',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserTypeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceProviderFormScreen(),
                ),
              ).then((value) {
                if (value != null && value is ServiceProvider) {
                  setState(() {
                    providers.add(value);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: providers.isEmpty
          ? _buildEmptyState()
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: providers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ServiceProviderCard(provider: providers[index]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServiceProviderFormScreen(),
            ),
          ).then((value) {
            if (value != null && value is ServiceProvider) {
              setState(() {
                providers.add(value);
              });
            }
          });
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إضافة جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 60,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'لا يوجد مقدمو خدمات حتى الآن',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'ابدأ بإضافة أول مقدم خدمة',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}