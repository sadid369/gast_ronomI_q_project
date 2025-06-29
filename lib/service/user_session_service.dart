import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../helper/local_db/local_db.dart';
import '../utils/app_const/app_const.dart';

class UserSessionService extends GetxService {
  static UserSessionService get instance => Get.find<UserSessionService>();
  
  String? _currentUserRole;
  int? _currentUserId;
  
  String? get currentUserRole => _currentUserRole;
  int? get currentUserId => _currentUserId;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserSession();
  }
  
  Future<void> _loadUserSession() async {
    _currentUserRole = await SharedPrefsHelper.getString(AppConstants.userRole);
    _currentUserId = await SharedPrefsHelper.getInt(AppConstants.userID);
    debugPrint("Loaded user session - Role: $_currentUserRole, ID: $_currentUserId");
  }
  
  Future<void> updateUserSession() async {
    await _loadUserSession();
  }
  
  Future<void> clearUserSession() async {
    _currentUserRole = null;
    _currentUserId = null;
    debugPrint("User session cleared");
  }
  
  bool hasSessionChanged(String? newRole, int? newUserId) {
    bool changed = _currentUserRole != newRole || _currentUserId != newUserId;
    if (changed) {
      debugPrint("Session changed - Old: $_currentUserRole/$_currentUserId, New: $newRole/$newUserId");
    }
    return changed;
  }
}
