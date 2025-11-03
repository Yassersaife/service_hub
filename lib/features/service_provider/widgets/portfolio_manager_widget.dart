// lib/features/service_provider/widgets/portfolio_manager_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:Lumixy/features/service_provider/models/portfolio_image.dart';

class PortfolioManagerWidget extends StatefulWidget {
  final List<PortfolioImage> existingImages;
  final List<String> newImagePaths;
  final Function(String) onImageAdded;
  final Function(int) onExistingImageDeleted; // للصور الموجودة على السيرفر
  final Function(String) onNewImageDeleted; // للصور الجديدة المحلية
  final int maxImages;

  const PortfolioManagerWidget({
    Key? key,
    required this.existingImages,
    required this.newImagePaths,
    required this.onImageAdded,
    required this.onExistingImageDeleted,
    required this.onNewImageDeleted,
    this.maxImages = 10,
  }) : super(key: key);

  @override
  State<PortfolioManagerWidget> createState() => _PortfolioManagerWidgetState();
}

class _PortfolioManagerWidgetState extends State<PortfolioManagerWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  int get _totalImagesCount =>
      widget.existingImages.length + widget.newImagePaths.length;

  bool get _canAddMore => _totalImagesCount < widget.maxImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.photo_library_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معرض الأعمال',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '$_totalImagesCount من ${widget.maxImages} صور',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (_canAddMore)
          _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : _showImageSourceDialog,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_photo_alternate, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'إضافة صور',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_totalImagesCount == 0) {
      return _buildEmptyState();
    }

    return _buildImagesGrid();
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد صور في المعرض',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أضف صور أعمالك لإظهار خبرتك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('إضافة صور'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _totalImagesCount + (_canAddMore ? 1 : 0),
      itemBuilder: (context, index) {
        // زر الإضافة
        if (index == _totalImagesCount) {
          return _buildAddImageTile();
        }

        // الصور الموجودة
        if (index < widget.existingImages.length) {
          return _buildExistingImageTile(widget.existingImages[index]);
        }

        // الصور الجديدة
        final newImageIndex = index - widget.existingImages.length;
        return _buildNewImageTile(widget.newImagePaths[newImageIndex]);
      },
    );
  }

  Widget _buildAddImageTile() {
    return InkWell(
      onTap: _showImageSourceDialog,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'إضافة',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingImageTile(PortfolioImage image) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => _showImagePreview(image.imageUrl, isNetwork: true),
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: _buildDeleteButton(
            onPressed: () => _confirmDelete(
              imageId: image.id,
              isExisting: true,
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_done, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  'محفوظة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewImageTile(String imagePath) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => _showImagePreview(imagePath, isNetwork: false),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: _buildDeleteButton(
            onPressed: () => _confirmDelete(
              imagePath: imagePath,
              isExisting: false,
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  'جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton({required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'اختر مصدر الصورة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_camera, color: AppColors.primary),
                ),
                title: const Text('الكاميرا'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_library, color: AppColors.secondary),
                ),
                title: const Text('المعرض'),
                subtitle: const Text('اختر صورة أو عدة صور'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_canAddMore) {
      _showMessage('لقد وصلت للحد الأقصى من الصور (${widget.maxImages})', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageAdded(image.path);
        _showMessage('تمت إضافة الصورة بنجاح');
      }
    } catch (e) {
      print('❌ خطأ في اختيار الصورة: $e');
      _showMessage('فشل اختيار الصورة', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickMultipleImages() async {
    final remainingSlots = widget.maxImages - _totalImagesCount;

    if (remainingSlots <= 0) {
      _showMessage('لقد وصلت للحد الأقصى من الصور', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) {
        setState(() => _isProcessing = false);
        return;
      }

      // أخذ الصور حسب المساحة المتاحة
      final imagesToAdd = images.take(remainingSlots).toList();

      for (var image in imagesToAdd) {
        widget.onImageAdded(image.path);
      }

      final addedCount = imagesToAdd.length;
      final skippedCount = images.length - addedCount;

      if (skippedCount > 0) {
        _showMessage(
          'تمت إضافة $addedCount ${addedCount == 1 ? 'صورة' : 'صور'}. تم تجاوز $skippedCount ${skippedCount == 1 ? 'صورة' : 'صور'} (الحد الأقصى: ${widget.maxImages})',
        );
      } else {
        _showMessage('تمت إضافة $addedCount ${addedCount == 1 ? 'صورة' : 'صور'} بنجاح');
      }
    } catch (e) {
      print('❌ خطأ في اختيار الصور: $e');
      _showMessage('فشل اختيار الصور', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _confirmDelete({int? imageId, String? imagePath, required bool isExisting}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: Text(
          isExisting
              ? 'هل تريد حذف هذه الصورة من المعرض؟ سيتم حذفها نهائياً.'
              : 'هل تريد إزالة هذه الصورة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isExisting && imageId != null) {
                widget.onExistingImageDeleted(imageId);
              } else if (!isExisting && imagePath != null) {
                widget.onNewImageDeleted(imagePath);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imagePath, {required bool isNetwork}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: isNetwork
                    ? Image.network(imagePath)
                    : Image.file(File(imagePath)),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}