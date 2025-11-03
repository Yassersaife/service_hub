// lib/features/service_provider/widgets/profile_setup_portfolio.dart

import 'package:flutter/material.dart';
import 'package:Lumixy/features/service_provider/models/profile_setup_data.dart';
import 'package:Lumixy/features/service_provider/widgets/portfolio_manager_widget.dart';
import 'profile_step_header.dart';

class ProfileSetupPortfolio extends StatelessWidget {
  final ProfileSetupData data;
  final VoidCallback onDataChanged;
  final Function(int)? onImageDeleted; // ✨ جديد - للصور الموجودة على السيرفر

  const ProfileSetupPortfolio({
    super.key,
    required this.data,
    required this.onDataChanged,
    this.onImageDeleted, // ✨ جديد
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileStepHeader(
            title: 'معرض الأعمال',
            subtitle: 'أضف صوراً من أعمالك السابقة لجذب العملاء',
            icon: Icons.photo_library,
          ),

          const SizedBox(height: 24),

          // ✨ استخدام PortfolioManagerWidget الجديد
          PortfolioManagerWidget(
            existingImages: data.existingPortfolioImages,
            newImagePaths: data.portfolioImages,
            onImageAdded: (path) {
              data.portfolioImages.add(path);
              onDataChanged();
            },
            onExistingImageDeleted: (imageId) {
              // إذا تم توفير callback للحذف من السيرفر
              if (onImageDeleted != null) {
                onImageDeleted!(imageId);
              } else {
                // وإلا نحذف محلياً فقط
                data.removeExistingPortfolioImage(imageId);
                onDataChanged();
              }
            },
            onNewImageDeleted: (path) {
              data.removeNewPortfolioImage(path);
              onDataChanged();
            },
            maxImages: 10,
          ),
        ],
      ),
    );
  }
}