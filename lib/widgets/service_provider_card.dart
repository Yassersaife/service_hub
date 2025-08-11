import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProvider provider;
  final bool showContactButtons;

  const ServiceProviderCard({
    super.key,
    required this.provider,
    this.showContactButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  provider.getServiceIcon(),
                  color: AppColors.primary,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      provider.getServiceLabel(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // المعلومات
          _buildInfoRow(Icons.location_on, provider.city),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone, provider.phone),

          if (provider.email != null && provider.email!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, provider.email!),
          ],

          if (provider.description != null &&
              provider.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.description!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ),
          ],

          // أزرار التواصل
          if (showContactButtons) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildContactButton(
                    'اتصال',
                    Icons.phone,
                    AppColors.primaryGradient,
                        () => _makePhoneCall(provider.phone),
                  ),
                ),

                if (provider.email != null && provider.email!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildContactButton(
                      'إيميل',
                      Icons.email,
                      AppColors.secondaryGradient,
                          () => print(''),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton(String text,
      IconData icon,
      Gradient gradient,
      VoidCallback onPressed,) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}