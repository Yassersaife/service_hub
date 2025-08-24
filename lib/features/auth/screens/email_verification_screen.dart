// // lib/features/auth/screens/email_verification_screen.dart
// import 'package:flutter/material.dart';
// import 'dart:async';
// import '../../../core/utils/app_colors.dart';
// import '../services/auth_service.dart';
// import '../models/user.dart';
// import '../../service_provider/screens/provider_dashboard_screen.dart';
//
// class EmailVerificationScreen extends StatefulWidget {
//   final String email;
//   final UserType userType;
//
//   const EmailVerificationScreen({
//     super.key,
//     required this.email,
//     required this.userType,
//   });
//
//   @override
//   State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
// }
//
// class _EmailVerificationScreenState extends State<EmailVerificationScreen>
//     with SingleTickerProviderStateMixin {
//   final _authService = AuthService();
//   final List<TextEditingController> _controllers = List.generate(
//     4, (index) => TextEditingController(),
//   );
//   final List<FocusNode> _focusNodes = List.generate(
//     4, (index) => FocusNode(),
//   );
//
//   late AnimationController _animationController;
//   late Animation<double> _pulseAnimation;
//
//   bool _isLoading = false;
//   bool _canResend = false;
//   int _resendCountdown = 60;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _startResendTimer();
//   }
//
//   void _setupAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _animationController.repeat(reverse: true);
//   }
//
//   void _startResendTimer() {
//     _canResend = false;
//     _resendCountdown = 60;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (_resendCountdown > 0) {
//             _resendCountdown--;
//           } else {
//             _canResend = true;
//             timer.cancel();
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _animationController.dispose();
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'تأكيد البريد الإلكتروني',
//           style: TextStyle(
//             color: Color(0xFF1E293B),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//
//               // أيقونة البريد الإلكتروني
//               _buildEmailIcon(),
//
//               const SizedBox(height: 32),
//
//               // العنوان والوصف
//               _buildHeader(),
//
//               const SizedBox(height: 40),
//
//               // حقول رمز التحقق
//               _buildVerificationFields(),
//
//               const SizedBox(height: 32),
//
//               // زر التحقق
//               _buildVerifyButton(),
//
//               const SizedBox(height: 24),
//
//               // إعادة الإرسال
//               _buildResendSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmailIcon() {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _pulseAnimation.value,
//           child: Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               gradient: AppColors.primaryGradient,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.email,
//               color: Colors.white,
//               size: 50,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         const Text(
//           'تحقق من بريدك الإلكتروني',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1E293B),
//           ),
//           textAlign: TextAlign.center,
//         ),
//
//         const SizedBox(height: 12),
//
//         RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             style: const TextStyle(
//               fontSize: 16,
//               color: Color(0xFF64748B),
//               height: 1.5,
//             ),
//             children: [
//               const TextSpan(text: 'أرسلنا رمز التحقق المكون من 4 أرقام إلى\n'),
//               TextSpan(
//                 text: widget.email,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildVerificationFields() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Text(
//             'أدخل رمز التحقق',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(4, (index) {
//               return SizedBox(
//                 width: 60,
//                 height: 60,
//                 child: TextField(
//                   controller: _controllers[index],
//                   focusNode: _focusNodes[index],
//                   textAlign: TextAlign.center,
//                   keyboardType: TextInputType.number,
//                   maxLength: 1,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E293B),
//                   ),
//                   decoration: InputDecoration(
//                     counterText: '',
//                     filled: true,
//                     fillColor: const Color(0xFFF8FAFC),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFFE2E8F0),
//                         width: 2,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: AppColors.primary,
//                         width: 2,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFFE2E8F0),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                   onChanged: (value) => _onCodeChanged(value, index),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVerifyButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: AppColors.secondaryGradient,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.secondary.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ElevatedButton(
//           onPressed: _isLoading ? null : _handleVerification,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: _isLoading
//               ? const SizedBox(
//             width: 24,
//             height: 24,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           )
//               : const Text(
//             'تأكيد الرمز',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResendSection() {
//     return Column(
//       children: [
//         const Text(
//           'لم تتلق الرمز؟',
//           style: TextStyle(
//             fontSize: 16,
//             color: Color(0xFF64748B),
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         if (_canResend)
//           GestureDetector(
//             onTap: _handleResend,
//             child: Text(
//               'إعادة الإرسال',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primary,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           )
//         else
//           Text(
//             'يمكنك إعادة الإرسال خلال $_resendCountdown ثانية',
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF9CA3AF),
//             ),
//           ),
//       ],
//     );
//   }
//
//   void _onCodeChanged(String value, int index) {
//     if (value.isNotEmpty) {
//       if (index < 3) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         _focusNodes[index].unfocus();
//         _handleVerification();
//       }
//     } else if (value.isEmpty && index > 0) {
//       _focusNodes[index - 1].requestFocus();
//     }
//   }
//
//   void _handleVerification() async {
//     final code = _controllers.map((c) => c.text).join();
//
//     if (code.length != 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('يرجى إدخال رمز التحقق كاملاً'),
//           backgroundColor: AppColors.error,
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final result = await _authService.verifyEmail(
//       email: widget.email,
//       code: code,
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (result.isSuccess) {
//       // دائماً نذهب لداشبورد مقدم الخدمة لأن العملاء لا يحتاجون حساب
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const ProviderDashboardScreen(),
//         ),
//       );
//     } else {
//       // مسح الحقول عند الخطأ
//       for (var controller in _controllers) {
//         controller.clear();
//       }
//       _focusNodes[0].requestFocus();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result.message),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }
//
//   void _handleResend() async {
//     final result = await _authService.resendVerificationCode(widget.email);
//
//     if (result.isSuccess) {
//       _startResendTimer();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result.message),
//           backgroundColor: AppColors.secondary,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result.message),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     }
//   }
// }