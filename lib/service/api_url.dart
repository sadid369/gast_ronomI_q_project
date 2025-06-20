class ApiUrl {
  static const baseUrl = "http://10.0.70.145:8001"; // LOCAL
  static const imageBaseUrl = '$baseUrl/';

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
  static const scanReceipt = "/receipt/scan-receipt/";
  static const transaction = "/report/api/v1/daily-category-spending/";
  static const transactionWithInvoicImage =
      "/report/api/v1/user_order_list/?page=";
}
