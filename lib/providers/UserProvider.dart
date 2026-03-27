import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _userName = 'Friend';
  String _profileImagePath = '';

  String get userName => _userName;
  String get profileImagePath => _profileImagePath;

  Future<void> loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName') ?? 'Friend';
      _profileImagePath = prefs.getString('profileImagePath') ?? '';
      notifyListeners();
    } catch (e) {
      _userName = 'Friend';
      _profileImagePath = '';
      notifyListeners();
    }
  }

  Future<void> setUserName(String name) async {
    if (name.trim().isEmpty) {
      _userName = 'Friend';
    } else {
      _userName = name.trim();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _userName);
    } catch (e) {
      // Handle error silently
    }
    notifyListeners();
  }

  Future<void> setProfileImage(String imagePath) async {
    _profileImagePath = imagePath;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', imagePath);
    } catch (e) {
      // Handle error silently
    }
    notifyListeners();
  }

  Future<void> clearProfileImage() async {
    _profileImagePath = '';
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profileImagePath');
    } catch (e) {
      // Handle error silently
    }
    notifyListeners();
  }

  void resetUserName() {
    _userName = 'Friend';
    try {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('userName', 'Friend');
      });
    } catch (e) {
      // Handle error silently
    }
    notifyListeners();
  }
}
