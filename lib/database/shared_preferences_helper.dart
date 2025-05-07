import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _mobileKey = 'mobile';
  static const String _addressKey = 'address';
  static const String _imagePathKey = 'imagePath'; // New key

  // SAVE DATA TO SHARED PREFERENCES
  static Future<void> saveProfileData({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String imagePath, // New parameter
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_mobileKey, mobile);
    await prefs.setString(_addressKey, address);
    await prefs.setString(_imagePathKey, imagePath); // Save image path
  }

  // LOAD DATA FROM SHARED PREFERENCES
  static Future<Map<String, String?>> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      _nameKey: prefs.getString(_nameKey),
      _emailKey: prefs.getString(_emailKey),
      _mobileKey: prefs.getString(_mobileKey),
      _addressKey: prefs.getString(_addressKey),
      _imagePathKey: prefs.getString(_imagePathKey), // Load image path
    };
  }
}
