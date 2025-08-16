// lib/features/auth/services/auth_service.dart
import 'dart:math';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _initializeDummyData();
  }
  User? _currentUser;
  Map<String, String> _verificationCodes = {};
  Map<String, User> _pendingUsers = {};
  Map<String, User> _registeredUsers = {};

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // تسجيل مستخدم جديد
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required UserType userType,
  }) async {
    try {
      // محاكاة التأخير
      await Future.delayed(const Duration(seconds: 1));

      // التحقق من وجود المستخدم
      if (_registeredUsers.containsKey(email)) {
        return AuthResult.error('البريد الإلكتروني مسجل مسبقاً');
      }

      // إنشاء المستخدم
      final user = User(
        id: _generateId(),
        name: name,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
        userType: userType,
      );

      // حفظ المستخدم كمؤقت
      _pendingUsers[email] = user;

      // إرسال رمز التحقق
      await _sendVerificationCode(email);

      return AuthResult.success('تم إرسال رمز التحقق إلى بريدك الإلكتروني');
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء التسجيل');
    }
  }

  // تسجيل الدخول
  Future<AuthResult> signIn({
    required String email,
    required String password, // مطلوب فقط للواجهة
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // البحث في المستخدمين المسجلين أو المؤقتين
      User? user = _registeredUsers[email] ?? _pendingUsers[email];

      // إذا لم يوجد المستخدم، إنشاء مستخدم جديد
      if (user == null) {
        user = User(
          id: _generateId(),
          name: email.split('@')[0], // استخدام الجزء الأول من الإيميل كاسم
          email: email,
          phone: '0599999999',
          createdAt: DateTime.now(),
          isEmailVerified: true, // تأكيد تلقائي
          userType: UserType.customer,
        );
        _registeredUsers[email] = user;
      }

      _currentUser = user;
      return AuthResult.success('تم تسجيل الدخول بنجاح');
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء تسجيل الدخول');
    }
  }

  // تأكيد البريد الإلكتروني
  Future<AuthResult> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final storedCode = _verificationCodes[email];
      if (storedCode == null) {
        return AuthResult.error('لم يتم إرسال رمز التحقق');
      }

      if (storedCode != code) {
        return AuthResult.error('رمز التحقق غير صحيح');
      }

      final user = _pendingUsers[email];
      if (user == null) {
        return AuthResult.error('المستخدم غير موجود');
      }

      // تأكيد البريد الإلكتروني
      final verifiedUser = user.copyWith(isEmailVerified: true);
      _registeredUsers[email] = verifiedUser;
      _currentUser = verifiedUser;

      // تنظيف البيانات المؤقتة
      _pendingUsers.remove(email);
      _verificationCodes.remove(email);

      return AuthResult.success('تم تأكيد البريد الإلكتروني بنجاح');
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء التحقق');
    }
  }

  // إعادة إرسال رمز التحقق
  Future<AuthResult> resendVerificationCode(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!_pendingUsers.containsKey(email)) {
        return AuthResult.error('البريد الإلكتروني غير موجود');
      }

      await _sendVerificationCode(email);
      return AuthResult.success('تم إعادة إرسال رمز التحقق');
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء إرسال الرمز');
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    _currentUser = null;
  }

  // إرسال رمز التحقق (محاكاة)
  Future<void> _sendVerificationCode(String email) async {
    final code = _generateVerificationCode();
    _verificationCodes[email] = code;

    // طباعة الرمز للاختبار
    print('Verification code for $email: $code');
  }

  // توليد رمز التحقق
  String _generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // توليد معرف فريد
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // إضافة بعض البيانات التجريبية
  void _initializeDummyData() {
    final dummyUser = User(
      id: '1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      phone: '0599123456',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isEmailVerified: true,
      userType: UserType.serviceProvider,
    );

    _registeredUsers['ahmed@example.com'] = dummyUser;
  }
}

class AuthResult {
  final bool isSuccess;
  final String message;

  AuthResult._(this.isSuccess, this.message);

  factory AuthResult.success(String message) => AuthResult._(true, message);
  factory AuthResult.error(String message) => AuthResult._(false, message);
}