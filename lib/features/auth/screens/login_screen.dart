import 'package:flutter/material.dart';
import 'package:service_hub/features/admin/admin_screen.dart';
import '../../../core/utils/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../../service_provider/screens/provider_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'تسجيل دخول مقدم خدمة',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              _buildHeader(),

              const SizedBox(height: 40),

              _buildLoginForm(),

              const SizedBox(height: 20),

              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(
              Icons.work,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Pro Connect',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'سجل دخولك لإدارة خدماتك',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
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
          children: [
            CustomTextField(
              label: 'البريد الإلكتروني',
              hint: 'أدخل بريدك الالكتروني',
              icon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),

            const SizedBox(height: 20),

            // كلمة المرور
            CustomTextField(
              label: 'كلمة المرور',
              hint: 'أدخل كلمة المرور',
              icon: Icons.lock,
              controller: _passwordController,
              required: true,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ليس لديك حساب؟ ',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Text(
                'سجل الآن',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.login(
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          final userName = AuthService.userName ?? 'المستخدم';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('مرحباً $userName'),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            if(AuthService.userType == 'admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminScreen(),
                ),
                    (route) => false,
              );
            } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProviderDashboardScreen(),
                  ),
                      (route) => false,
                );
            }
          }
        } else {
          // إظهار رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Login error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}