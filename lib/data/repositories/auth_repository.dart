import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  // Simulate login
  Future<UserModel> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Simulate successful login
    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      isGuest: false,
      createdAt: DateTime.now(),
    );

    await _saveUserData(user);
    return user;
  }

  // Simulate registration
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      isGuest: false,
      createdAt: DateTime.now(),
    );

    await _saveUserData(user);
    return user;
  }

  // Guest login
  Future<UserModel> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = UserModel.guest();
    await _saveUserData(user);
    return user;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyIsLoggedIn);
    await prefs.remove(AppConstants.keyIsGuest);
    await prefs.remove(AppConstants.keyUserId);
    await prefs.remove(AppConstants.keyUserName);
    await prefs.remove(AppConstants.keyUserEmail);
  }

  // Check if user is logged in
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final isGuest = prefs.getBool(AppConstants.keyIsGuest) ?? false;
    if (isGuest) return UserModel.guest();

    return UserModel(
      id: prefs.getString(AppConstants.keyUserId) ?? '',
      name: prefs.getString(AppConstants.keyUserName) ?? '',
      email: prefs.getString(AppConstants.keyUserEmail) ?? '',
      isGuest: false,
      createdAt: DateTime.now(),
    );
  }

  // Check first launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsFirstLaunch, false);
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setBool(AppConstants.keyIsGuest, user.isGuest);
    await prefs.setString(AppConstants.keyUserId, user.id);
    await prefs.setString(AppConstants.keyUserName, user.name);
    await prefs.setString(AppConstants.keyUserEmail, user.email);
  }
}
