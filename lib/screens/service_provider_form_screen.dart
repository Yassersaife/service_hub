import 'package:flutter/material.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import 'service_providers_list_screen.dart';

class ServiceProviderFormScreen extends StatefulWidget {
  const ServiceProviderFormScreen({super.key});

  @override
  State<ServiceProviderFormScreen> createState() => _ServiceProviderFormScreenState();
}

class _ServiceProviderFormScreenState extends State<ServiceProviderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedService;
  String? _selectedCity;

  final List<Map<String, String>> _serviceTypes = [
    {'value': 'photographer', 'label': 'مصور'},
    {'value': 'video-editor', 'label': 'مونتاج فيديوهات'},
    {'value': 'photo-editor', 'label': 'تعديل صور'},
    {'value': 'printer', 'label': 'طباعة صور'},
  ];

  final List<String> _cities = [
    'نابلس',
    'رام الله',
    'القدس',
    'الخليل',
    'بيت لحم',
    'جنين',
    'طولكرم'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'معلومات مقدم الخدمة',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'املأ البيانات التالية لإضافة خدمتك',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // الاسم الكامل
                    CustomTextField(
                      label: 'الاسم الكامل',
                      hint: 'أدخل اسمك الكامل',
                      icon: Icons.person,
                      controller: _nameController,
                      required: true,
                    ),

                    const SizedBox(height: 20),

                    // نوع الخدمة
                    CustomDropdown(
                      label: 'نوع الخدمة',
                      hint: 'اختر نوع الخدمة',
                      value: _selectedService,
                      items: _serviceTypes.map((e) => e['value']!).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value;
                        });
                      },
                      required: true,
                    ),

                    const SizedBox(height: 20),

                    // المدينة
                    CustomDropdown(
                      label: 'المدينة',
                      hint: 'اختر المدينة',
                      value: _selectedCity,
                      items: _cities,
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      required: true,
                    ),

                    const SizedBox(height: 20),

                    // رقم الهاتف
                    CustomTextField(
                      label: 'رقم الهاتف',
                      hint: '05xxxxxxxx',
                      icon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      required: true,
                    ),

                    const SizedBox(height: 20),

                    // البريد الإلكتروني
                    CustomTextField(
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // وصف الخدمة
                    CustomTextField(
                      label: 'وصف الخدمة',
                      hint: 'اكتب وصفاً مختصراً عن خدمتك...',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 40),

                    // الأزرار
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFD1D5DB),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'رجوع',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.secondaryGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'إضافة الخدمة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_nameController.text.isNotEmpty &&
        _selectedService != null &&
        _selectedCity != null &&
        _phoneController.text.isNotEmpty) {

      final provider = ServiceProvider(
        name: _nameController.text,
        service: _selectedService!,
        city: _selectedCity!,
        phone: _phoneController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceProvidersListScreen(newProvider: provider),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}