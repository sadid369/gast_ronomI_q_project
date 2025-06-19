class ApiUrl {
  static const baseUrl = "http://10.0.70.145:8001"; // LOCAL
  static const imageBaseUrl = '$baseUrl/';

  static const confirmSubscription =
      "/subscription/api/v1/create-payment-intent/";
  static const subscriptionPackages =
      "/subscriptions_plan/api/v1/subscription/plans/";

  static const signUpClient = "/user/api/v1/register/";
  static const signInClient = "/user/api/v1/user/login/";
}
