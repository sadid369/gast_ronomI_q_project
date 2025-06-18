import 'package:get/get.dart';
import 'package:groc_shopy/presentation/screens/home/controller/home_controller.dart';
import 'package:groc_shopy/presentation/screens/scannedItemsScreen/scanned_items_controller/scanned_items_controller.dart';

import '../presentation/screens/auth/controller/auth_controller.dart';
import '../presentation/screens/transaction_history/transaction_history_controller/transaction_history_controller.dart';
import '../presentation/widgets/custom_navbar/navbar_controller.dart';

void initGetx() {
  // ================== Global Controller ==================

  // ================== Auth Controller ==================
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => BottomNavController(), fenix: true);
  Get.lazyPut(() => TransactionHistoryController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  // Get.lazyPut(() => ScannedItemsController(), fenix: true);

  // ================================= Worker ======================================

  // ================================= Client ======================================
}
