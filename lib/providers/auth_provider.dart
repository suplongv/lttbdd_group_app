import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider() {
    _user = _authService.currentUser;
  }

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định khi đăng ký.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Không thể gửi email đặt lại mật khẩu.';
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _setLoading(false);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
