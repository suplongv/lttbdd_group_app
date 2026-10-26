import 'dart:async';
import '../models/user_model.dart';

/// Dịch vụ Xác thực người dùng (AuthService).
/// 
/// Thiết kế mô phỏng chuẩn giao tiếp của Firebase Authentication:
/// - signInWithEmailAndPassword
/// - createUserWithEmailAndPassword
/// - signOut
/// - sendPasswordResetEmail
/// 
/// Khi bạn đã cấu hình Firebase Console xong và thêm thư viện `firebase_auth`,
/// bạn chỉ cần thay thế phần xử lý bên trong bằng `FirebaseAuth.instance.*`.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Danh sách tài khoản mẫu trong bộ nhớ
  final Map<String, _StoredUser> _users = {
    'demo@gmail.com': _StoredUser(
      password: 'password123',
      user: AppUser(
        uid: 'user_demo_01',
        email: 'demo@gmail.com',
        displayName: 'Nguyễn Văn Demo',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ),
    'admin@sochitieu.vn': _StoredUser(
      password: 'password123',
      user: AppUser(
        uid: 'user_admin_01',
        email: 'admin@sochitieu.vn',
        displayName: 'Chủ Quỹ Thông Thái',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ),
  };

  AppUser? _currentUser;
  final _authStateController = StreamController<AppUser?>.broadcast();

  AppUser? get currentUser => _currentUser;
  Stream<AppUser?> get authStateChanges => _authStateController.stream;

  /// Đăng nhập bằng Email và Mật khẩu
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Giả lập độ trễ mạng như Firebase
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final stored = _users[normalizedEmail];

    if (stored == null) {
      throw AuthException('Không tìm thấy tài khoản với email này.');
    }

    if (stored.password != password) {
      throw AuthException('Mật khẩu không chính xác. Vui lòng thử lại.');
    }

    _currentUser = stored.user;
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  /// Đăng ký tài khoản mới bằng Email và Mật khẩu
  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final normalizedEmail = email.trim().toLowerCase();

    if (_users.containsKey(normalizedEmail)) {
      throw AuthException('Email này đã được sử dụng bởi một tài khoản khác.');
    }

    if (password.length < 6) {
      throw AuthException('Mật khẩu phải có độ dài ít nhất 6 ký tự.');
    }

    final newUser = AppUser(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: displayName.trim().isEmpty ? 'Người dùng mới' : displayName.trim(),
      createdAt: DateTime.now(),
    );

    _users[normalizedEmail] = _StoredUser(
      password: password,
      user: newUser,
    );

    _currentUser = newUser;
    _authStateController.add(_currentUser);
    return newUser;
  }

  /// Gửi email khôi phục mật khẩu
  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final normalizedEmail = email.trim().toLowerCase();

    if (!_users.containsKey(normalizedEmail)) {
      throw AuthException('Không tìm thấy tài khoản với email này.');
    }
    // Giả lập gửi email thành công
  }

  /// Đăng xuất tài khoản
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }
}

class _StoredUser {
  final String password;
  final AppUser user;

  _StoredUser({required this.password, required this.user});
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
