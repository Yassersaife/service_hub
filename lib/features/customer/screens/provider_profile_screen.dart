import 'package:flutter/material.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/app_colors.dart';

class ProviderProfileScreen extends StatefulWidget {
  final ProviderProfile provider;

  const ProviderProfileScreen({super.key, required this.provider});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // طباعة معلومات للتشخيص
    print('Provider Name: ${widget.provider.displayName}');
    print('Profile Image URL: ${widget.provider.profileImageUrl}');
    print('Profile Image: ${widget.provider.profileImage}');
    print('Portfolio Images: ${widget.provider.allPortfolioImages}');
    print('Social Media: ${widget.provider.socialMedia}');
    print('Services Count: ${widget.provider.servicesCount}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            foregroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                      AppColors.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 25,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildProfileImage(),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.provider.displayName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (widget.provider.isVerified) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                              if (widget.provider.isFeatured) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          // نوع الخدمة
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              widget.provider.categoryName ?? 'غير محدد',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // المدينة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.provider.city,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
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
          ),

          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStat(
                      'انضم للتطبيق',
                      widget.provider.getExperienceText(),
                      Icons.timeline,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStat(
                      'الأعمال',
                      '${widget.provider.allPortfolioImages.length}',
                      Icons.photo_library,
                      AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickStat(
                      'الخدمات',
                      '${widget.provider.servicesCount}',
                      Icons.star_outline,
                      AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // التبويبات
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'نظرة عامة'),
                  Tab(text: 'معرض الأعمال'),
                  Tab(text: 'التواصل'),
                ],
              ),
            ),
          ),

          // محتوى التبويبات
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPortfolioTab(),
                _buildContactTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    // التحقق من profileImageUrl أولاً ثم profileImage
    String? imageUrl;
    if (widget.provider.profileImageUrl != null && widget.provider.profileImageUrl!.isNotEmpty) {
      imageUrl = widget.provider.profileImageUrl;
    } else if (widget.provider.profileImage != null && widget.provider.profileImage!.isNotEmpty) {
      imageUrl = widget.provider.profileImage;
    }

    if (imageUrl != null) {
      print('Loading profile image: $imageUrl');
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading profile image: $error');
            return _buildDefaultAvatar(120);
          },
        ),
      );
    } else {
      return _buildDefaultAvatar(120);
    }
  }

  Widget _buildDefaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.provider.getServiceColor(),
            widget.provider.getServiceColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(
        widget.provider.getServiceIcon(),
        color: Colors.white,
        size: size * 0.4,
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الوصف
          if (widget.provider.description != null && widget.provider.description!.isNotEmpty) ...[
            _buildSectionCard(
              'نبذة عن الخدمة',
              Icons.description_outlined,
              child: Text(
                widget.provider.description!,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // الخدمات المقدمة
          if (widget.provider.hasServices) ...[
            _buildSectionCard(
              'الخدمات المقدمة',
              Icons.star_border,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.provider.services!.map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      service['name'] ?? 'خدمة',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // معلومات إضافية
          _buildSectionCard(
            'معلومات إضافية',
            Icons.info_outline,
            child: Column(
              children: [
                if (widget.provider.address != null && widget.provider.address!.isNotEmpty)
                  _buildInfoRow(
                    Icons.place_outlined,
                    'العنوان',
                    widget.provider.address!,
                  ),
                if (widget.provider.workHours != null && widget.provider.workHours!.isNotEmpty)
                  _buildInfoRow(
                    Icons.access_time_outlined,
                    'ساعات العمل',
                    widget.provider.workHours!,
                  ),
                _buildInfoRow(
                  Icons.location_city,
                  'المدينة',
                  widget.provider.city,
                ),
                if (widget.provider.userPhone != null && widget.provider.userPhone!.isNotEmpty)
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'رقم الهاتف',
                    widget.provider.userPhone!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    final portfolioImages = widget.provider.allPortfolioImages;
    print('Building portfolio tab with ${portfolioImages.length} images');

    if (portfolioImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد أعمال محفوظة بعد',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم عرض أعمال مقدم الخدمة هنا',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: portfolioImages.length,
        itemBuilder: (context, index) {
          final imageUrl = portfolioImages[index];
          print('Building portfolio image $index: $imageUrl');

          return GestureDetector(
            onTap: () => _showImageDialog(imageUrl, index),
            child: Hero(
              tag: 'portfolio_$index',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading portfolio image $index: $error');
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'فشل تحميل الصورة',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildSectionCard(
            'طرق التواصل',
            Icons.contact_phone,
            child: Column(
              children: [
                if (widget.provider.userPhone != null && widget.provider.userPhone!.isNotEmpty) ...[
                  _buildContactButton(
                    'اتصال مباشر',
                    Icons.phone,
                    AppColors.primary,
                        () => _makePhoneCall(),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.provider.whatsappNumber != null && widget.provider.whatsappNumber!.isNotEmpty) ...[
                  _buildContactButton(
                    'واتساب',
                    Icons.chat,
                    AppColors.secondary,
                        () => _sendWhatsApp(),
                  ),
                  const SizedBox(height: 12),
                ],
                // إذا لم توجد أرقام، استخدم رقم افتراضي
                if ((widget.provider.userPhone == null || widget.provider.userPhone!.isEmpty) &&
                    (widget.provider.whatsappNumber == null || widget.provider.whatsappNumber!.isEmpty)) ...[
                  _buildContactButton(
                    'تواصل معنا',
                    Icons.phone,
                    AppColors.primary,
                        () => _makePhoneCall(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (_hasSocialMedia()) ...[
            _buildSectionCard(
              'وسائل التواصل الاجتماعي',
              Icons.share,
              child: Column(
                children: _buildSocialMediaButtons(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasSocialMedia() {
    return widget.provider.socialMedia != null &&
        widget.provider.socialMedia!.isNotEmpty &&
        widget.provider.socialMedia!.values.any((value) => value.toString().isNotEmpty);
  }

  List<Widget> _buildSocialMediaButtons() {
    List<Widget> buttons = [];

    if (widget.provider.socialMedia == null) return buttons;

    if (widget.provider.socialMedia!['instagram'] != null &&
        widget.provider.socialMedia!['instagram'].toString().isNotEmpty) {
      buttons.add(_buildContactButton(
        'Instagram',
        Icons.camera_alt,
        const Color(0xFFE4405F),
            () => _openInstagram(),
      ));
      buttons.add(const SizedBox(height: 12));
    }

    // Facebook
    if (widget.provider.socialMedia!['facebook'] != null &&
        widget.provider.socialMedia!['facebook'].toString().isNotEmpty) {
      buttons.add(_buildContactButton(
        'Facebook',
        Icons.facebook,
        const Color(0xFF1877F2),
            () => _openFacebook(),
      ));
      buttons.add(const SizedBox(height: 12));
    }

    if (buttons.isNotEmpty && buttons.last is SizedBox) {
      buttons.removeLast();
    }

    return buttons;
  }

  void _openInstagram() async {
    final username = widget.provider.socialMedia?['instagram']?.toString() ?? '';
    if (username.isEmpty) return;

    final instagramUrl = 'https://instagram.com/$username';
    final instagramAppUrl = 'instagram://user?username=$username';

    try {
      if (await canLaunchUrl(Uri.parse(instagramAppUrl))) {
        await launchUrl(Uri.parse(instagramAppUrl));
      } else if (await canLaunchUrl(Uri.parse(instagramUrl))) {
        await launchUrl(
          Uri.parse(instagramUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackbar('تعذر فتح Instagram');
      }
    } catch (e) {
      print('Error opening Instagram: $e');
      _showErrorSnackbar('تعذر فتح Instagram');
    }
  }

  void _openFacebook() async {
    final username = widget.provider.socialMedia?['facebook']?.toString() ?? '';
    if (username.isEmpty) return;

    final facebookUrl = 'https://facebook.com/$username';
    final facebookAppUrl = 'fb://profile/$username';

    try {
      if (await canLaunchUrl(Uri.parse(facebookAppUrl))) {
        await launchUrl(Uri.parse(facebookAppUrl));
      } else if (await canLaunchUrl(Uri.parse(facebookUrl))) {
        await launchUrl(
          Uri.parse(facebookUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackbar('تعذر فتح Facebook');
      }
    } catch (e) {
      print('Error opening Facebook: $e');
      _showErrorSnackbar('تعذر فتح Facebook');
    }
  }

  Widget _buildSectionCard(String title, IconData icon, {required Widget child}) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _makePhoneCall() async {
    final phoneNumber = widget.provider.userPhone?.isNotEmpty == true
        ? widget.provider.userPhone!
        : '';

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackbar('لا يمكن إجراء المكالمة');
      }
    } catch (e) {
      print('Error making phone call: $e');
      _showErrorSnackbar('حدث خطأ أثناء المحاولة');
    }
  }

  void _sendWhatsApp() async {
    final phoneNumber = widget.provider.whatsappNumber?.isNotEmpty == true
        ? widget.provider.whatsappNumber!
        : (widget.provider.userPhone?.isNotEmpty == true
        ? widget.provider.userPhone!
        : '0568972337');

    final message = 'مرحباً ${widget.provider.displayName}, أريد الاستفسار عن خدمة ${widget.provider.categoryName ?? "الخدمة"}';
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/${phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar('لا يمكن فتح واتساب');
      }
    } catch (e) {
      print('Error opening WhatsApp: $e');
      _showErrorSnackbar('حدث خطأ أثناء المحاولة');
    }
  }

  void _showImageDialog(String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'portfolio_$index',
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: Text(
                              'فشل تحميل الصورة',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
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
}