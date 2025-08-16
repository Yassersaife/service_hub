import 'package:flutter/material.dart';
import 'package:service_hub/features/customer/screens/provider_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/service_provider/models/provider_profile.dart';
import '../utils/app_colors.dart';
import '../widgets/rating_stars.dart';

class ServiceProviderCardGuest extends StatelessWidget {
  final ProviderProfile profile;

  const ServiceProviderCardGuest({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // صورة البروفايل
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: profile.profileImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    profile.profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(),
                  ),
                )
                    : _buildDefaultAvatar(),
              ),

              const SizedBox(width: 16),

              // المعلومات الأساسية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم مقدم الخدمة مع شارة التوثيق
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.name ?? 'مقدم الخدمة',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.verified,
                            color: AppColors.secondary,
                            size: 16,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // نوع الخدمة
                    Text(
                      profile.getServiceLabel(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // التقييم والموقع
                    Row(
                      children: [
                        RatingStars(
                          rating: profile.rating,
                          size: 14,
                          showRating: false,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${profile.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${profile.reviewsCount})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          profile.city,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // سنوات الخبرة
                    Text(
                      profile.getExperienceText(),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // سهم للانتقال
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context) async {
    final phoneNumber = profile.phoneNumber ?? '0599123456';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackbar(context, 'لا يمكن إجراء المكالمة');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'حدث خطأ أثناء المحاولة');
    }
  }

  void _sendWhatsApp(BuildContext context) async {
    final phoneNumber = profile.whatsappNumber ?? '970599123456';
    final message = 'مرحباً ${profile.name ??
        ''}, أريد الاستفسار عن خدمة ${profile.getServiceLabel()}';
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar(context, 'لا يمكن فتح واتساب');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'حدث خطأ أثناء المحاولة');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.9),
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        profile.getServiceIcon(),
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProviderProfileScreen(
          provider: profile,
        ),
      ),
    );
  }
}