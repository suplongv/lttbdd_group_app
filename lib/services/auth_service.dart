import 'dart:async';
import '../models/user_model.dart';

/// Dịch vụ Xác thực người dùng (AuthService).
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, _StoredUser> _users = {
    'demo@gmail.com': _StoredUser(
      password: 'password123',
      user: AppUser(
        uid: 'user_demo_01',
        email: 'demo@gmail.com',
        displayName: 'Nguyễn Văn A',
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

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));

    final normalizedEmail = email.trim().toLowerCase();
    final stored = _users[normalizedEmail];

    if (stored == null) {
      throw AuthException('Không tìm thấy tài khoản với thông tin này.');
    }

    if (stored.password != password) {
      throw AuthException('Mật khẩu không chính xác. Vui lòng thử lại.');
    }

    _currentUser = stored.user;
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 550));

    final normalizedEmail = email.trim().toLowerCase();

    if (_users.containsKey(normalizedEmail)) {
      throw AuthException('Tài khoản này đã tồn tại.');
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

  Future<AppUser?> updateDisplayName(String displayName) async {
    if (_currentUser == null) return null;
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return _currentUser;

    final updated = _currentUser!.copyWith(displayName: trimmed);
    _currentUser = updated;
    final existing = _users[updated.email];
    if (existing != null) {
      _users[updated.email] = _StoredUser(password: existing.password, user: updated);
    }
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = email.trim().toLowerCase();

    if (!_users.containsKey(normalizedEmail)) {
      throw AuthException('Không tìm thấy tài khoản với email này.');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 250));
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
