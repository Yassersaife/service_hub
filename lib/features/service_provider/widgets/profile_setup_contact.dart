import 'package:Lumixy/features/service_provider/widgets/whatsapp_input_field.dart';
import 'package:flutter/material.dart';
import 'package:Lumixy/widgets/custom_text_field.dart';
import '../models/profile_setup_data.dart';
import 'profile_step_header.dart';

class ProfileSetupContact extends StatefulWidget {
  final ProfileSetupData data;
  final VoidCallback onDataChanged;

  const ProfileSetupContact({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  State<ProfileSetupContact> createState() => _ProfileSetupContactState();
}

class _ProfileSetupContactState extends State<ProfileSetupContact> {
  final _whatsappController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _twitterController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    _whatsappController.text = widget.data.whatsappNumber;
    _instagramController.text = widget.data.socialMedia['instagram'] ?? '';
    _websiteController.text = widget.data.socialMedia['website'] ?? '';
  }

  @override
  void dispose() {
    _whatsappController.dispose();
    _instagramController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileStepHeader(
            title: 'معلومات التواصل',
            subtitle: 'أضف طرق التواصل معك لتسهيل وصول العملاء',
            icon: Icons.contact_page,
          ),

          const SizedBox(height: 24),

          _buildWhatsAppSection(),

          const SizedBox(height: 24),

          _buildSocialMediaSection(),

          const SizedBox(height: 24),

          _buildContactTips(),
        ],
      ),
    );
  }

  Widget _buildWhatsAppSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF16A34A).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.phone,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رقم الواتساب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'الطريقة الأسرع للتواصل مع العملاء',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          WhatsappInputField(
            initialNumber: widget.data.whatsappNumber,
            onChanged: (value) {
              widget.data.whatsappNumber = value;
              widget.onDataChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'وسائل التواصل الاجتماعي (اختياري)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'أضف حساباتك على وسائل التواصل لتعزيز ثقة العملاء',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 16),

        _buildSocialMediaField(
          'Instagram',
          'اسم المستخدم على إنستغرام',
          Icons.camera_alt,
          const Color(0xFFE4405F),
          _instagramController,
          'instagram',
        ),


        const SizedBox(height: 16),

        _buildSocialMediaField(
          'الموقع الإلكتروني',
          'رابط موقعك الشخصي أو محفظة أعمالك',
          Icons.language,
          const Color(0xFF6366F1),
          _websiteController,
          'website',
        ),
      ],
    );
  }

  Widget _buildSocialMediaField(
      String platform,
      String hint,
      IconData icon,
      Color color,
      TextEditingController controller,
      String key,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: CustomTextField(
        controller: controller,
        label: platform,
        hint: hint,
        icon: icon,
        onChanged: (value) {
          if (value.isNotEmpty) {
            widget.data.socialMedia[key] = value;
          } else {
            widget.data.socialMedia.remove(key);
          }
          widget.onDataChanged();
        },
      ),
    );
  }

  Widget _buildContactTips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: const Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'نصائح مهمة للتواصل',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('تأكد من صحة رقم الواتساب لتسهيل التواصل'),
          _buildTipItem('استخدم أسماء مستخدمين واضحة وسهلة الحفظ'),
          _buildTipItem('حدّث حساباتك بانتظام لإظهار أعمالك الجديدة'),
          _buildTipItem('اربط حساباتك المهنية فقط المتعلقة بعملك'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
}