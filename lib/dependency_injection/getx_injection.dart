import 'package:get/get.dart';

import '../presentation/screens/auth/controller/auth_controller.dart';

void initGetx() {
  // ================== Global Controller ==================

  // ================== Auth Controller ==================
  Get.lazyPut(() => AuthController(), fenix: true);

  // ================================= Worker ======================================

  // ================================= Client ======================================
}
