import 'package:flutter/material.dart';
import 'package:Lumixy/features/service_provider/models/provider_profile.dart';
import '../features/customer/screens/provider_profile_screen.dart';
import '../core/utils/app_colors.dart';

class BeautifulProviderCard extends StatelessWidget {
  final ProviderProfile provider;
  final bool isTopProvider;

  const BeautifulProviderCard({
    super.key,
    required this.provider,
    this.isTopProvider = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderProfileScreen(provider: provider),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الجزء العلوي - الصورة والمعلومات الأساسية
              Row(
                children: [
                  // صورة البروفايل
                  Stack(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: provider.getServiceColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: _buildProfileImage(),
                      ),

                      // شارة الأفضل أو المميز
                      if (isTopProvider || provider.isFeatured)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: provider.isFeatured ? Colors.purple : Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: (provider.isFeatured ? Colors.purple : Colors.amber)
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              provider.isFeatured ? Icons.star : Icons.trending_up,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),

                      // شارة التوثيق
                      if (provider.isVerified)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // معلومات المقدم
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusBadge(),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // نوع الخدمة/الفئة
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: provider.getServiceColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                provider.getServiceIcon(),
                                color: provider.getServiceColor(),
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                provider.categoryName ?? 'غير محدد',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: provider.getServiceColor(),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // الجزء السفلي - الموقع والخدمات
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // الموقع
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              provider.city,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // فاصل
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.grey.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),

                    // عدد الخدمات أو الخبرة
                    Row(
                      children: [
                        Icon(
                          provider.hasServices ? Icons.build_outlined : Icons.work_outline,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          provider.hasServices
                              ? '${provider.servicesCount} خدمة'
                              : provider.getExperienceText(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (provider.profileImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          provider.profileImageUrl!,
          fit: BoxFit.cover,
          width: 65,
          height: 65,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        ),
      );
    } else if (provider.profileImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(
          provider.profileImage!,
          fit: BoxFit.cover,
          width: 65,
          height: 65,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        ),
      );
    } else {
      return _buildFallbackIcon();
    }
  }

  Widget _buildFallbackIcon() {
    return Icon(
      provider.getServiceIcon(),
      color: provider.getServiceColor(),
      size: 30,
    );
  }

  Widget _buildStatusBadge() {
    if (!provider.isVerified && !provider.isFeatured && !isTopProvider) {
      return const SizedBox.shrink();
    }

    String text = '';
    Color backgroundColor = Colors.grey;
    Color textColor = Colors.white;

    if (provider.isVerified && provider.isFeatured) {
      text = 'موثق ومميز';
      backgroundColor = Colors.purple;
    } else if (provider.isFeatured || isTopProvider) {
      text = 'مميز';
      backgroundColor = Colors.amber;
      textColor = Colors.black87;
    } else if (provider.isVerified) {
      text = 'موثق';
      backgroundColor = Colors.green;
    }

    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: backgroundColor,
        ),
      ),
    );
  }
}