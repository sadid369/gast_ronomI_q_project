class ApiUrl {
  static const baseUrl = "http://10.10.7.85:8001"; // LOCAL
  static const imageBaseUrl = '$baseUrl';

  static const confirmSubscription =
      "/subscription/api/v1/create-payment-intent/";
  static const subscriptionPackages =
      "/subscriptions_plan/api/v1/subscription/plans/";

  static const signUpClient = "/user/api/v1/register/";
  static const signInClient = "/user/api/v1/user/login/";
  static const sendResetOtp = "/user/api/v1/send-reset-otp/";
  static const verifyResetOtp = "/user/api/v1/verify-reset-otp/";
  static const setNewPasswordAfterOtp =
      "/user/api/v1/set-new-password-after-otp/";
  static const lastScanInvoiceItems = "/report/orders/recent/";
  static const employeeRecentOrders = "/report/employee/recent-orders/";
  static const scanReceipt = "/receipt/scan-receipt/";
  static const transaction = "/report/api/v1/daily-category-spending/";
  static const transactionWithInvoicImage =
      "/report/api/v1/user_order_list/?page=";
  static const employeeSignIn = "/employee/api/v1/employee/login/";

  // Add the monthly report endpoint
  static String monthlyReport(int year, int month) =>
      "/report/reports/monthly/$year/$month/";

  // Add image upload endpoints
  static String adminImageUpload(int userId) =>
      "/user/api/v1/user/uploadimage/$userId/";
  static String employeeImageUpload(int userId) =>
      "/employee/api/v1/user/employeeImageUpload/$userId/";

  static String employeeScanReceipt(int id) =>
      "$baseUrl/receipt/employee/scan-receipt/$id/";
  static String employeeDailySpending(int id) =>
      "$baseUrl/report/api/v1/employee/daily-spending/$id";
  static const employeeOrderList = "/report/api/v1/employee_order_list/?page=";
  static String employeeOrderListWithId(int id, int page) =>
      "$baseUrl/report/api/v1/employee_order_list/$id/?page=$page";
  static const logout = "/user/logout/";
  static const googleAuth = "/dj-rest-auth/google/";
}
