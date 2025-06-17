import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/presentation/screens/auth/admin_signup_screen%20.dart';
import 'package:groc_shopy/presentation/screens/auth/auth_screen.dart';
import 'package:groc_shopy/presentation/screens/auth/forgot_password_screen.dart';
import 'package:groc_shopy/presentation/screens/auth/password_reset_confirm_screen.dart';
import 'package:groc_shopy/presentation/screens/auth/set_new_password_screen.dart';
import 'package:groc_shopy/presentation/screens/auth/update_password_success_screen.dart';
import 'package:groc_shopy/presentation/screens/auth/verify_code_screen.dart';
import 'package:groc_shopy/presentation/screens/home/home_screen.dart';
import 'package:groc_shopy/presentation/screens/main/main_screen.dart';
import 'package:groc_shopy/presentation/screens/profile/profile_screen.dart';
import 'package:groc_shopy/presentation/screens/scan/scan_screen.dart';
import 'package:groc_shopy/presentation/screens/stripe/stripe_payment_screen.dart';
import 'package:groc_shopy/presentation/screens/transaction_history/transaction_history_screen.dart';
import 'package:groc_shopy/presentation/widgets/payment_modal/payment_modal.dart';
import 'package:groc_shopy/presentation/widgets/paypal/paypal.dart';
import 'package:groc_shopy/presentation/widgets/subscription_modal/subscription_modal.dart';

import '../../presentation/screens/report/report_screen.dart';
import '../../presentation/screens/scannedItemsScreen/scanned_items_screen.dart';
import '../../presentation/screens/splash_screen/splash_screen.dart';
import '../../presentation/widgets/error_screen/error_screen.dart';
import '../../presentation/widgets/subscription_plans/subscription_plans.dart';
// import 'route_observer.dart';
import 'route_path.dart';

class AppRouter {
  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _scanNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'scan');
  static final _historyNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'history');
  static final _profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profile');

  static final GoRouter initRoute = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePath.splashScreen.addBasePath,
    debugLogDiagnostics: true,
    routes: [
      ///======================= Splash & Auth Routes =======================
      GoRoute(
        name: RoutePath.splashScreen,
        path: RoutePath.splashScreen.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        name: RoutePath.stripe,
        path: RoutePath.stripe.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: StripePaymentScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.auth,
        path: RoutePath.auth.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AuthScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      ///======================= Main Shell Route =======================
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (ctx, state, shell) => MainScreen(navigationShell: shell),
        branches: [
          /// Home Branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                name: RoutePath.home,
                path: RoutePath.home.addBasePath,
                pageBuilder: (ctx, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),

          /// Scan Branch with nested route
          StatefulShellBranch(
            navigatorKey: _scanNavigatorKey,
            routes: [
              GoRoute(
                name: RoutePath.scan,
                path: RoutePath.scan.addBasePath,
                pageBuilder: (ctx, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ScanScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
                routes: [
                  GoRoute(
                    name: RoutePath.scannedItemsScreen,
                    path: RoutePath.scannedItemsScreen.addBasePath,
                    pageBuilder: (ctx, state) {
                      final extras = state.extra as Map<String, dynamic>;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: ScannedItemsScreen(extras: extras),
                        transitionsBuilder: _fadeTransition,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Transaction History Branch
          StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: [
              GoRoute(
                name: RoutePath.transactionHistory,
                path: RoutePath.transactionHistory.addBasePath,
                pageBuilder: (ctx, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: TransactionHistoryScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),

          /// Profile Branch
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                name: RoutePath.profile,
                path: RoutePath.profile.addBasePath,
                pageBuilder: (ctx, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),
        ],
      ),

      ///======================= Modal Routes =======================
      GoRoute(
        name: RoutePath.subscription,
        path: RoutePath.subscription.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SubscriptionModal(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.paymentModal,
        path: RoutePath.paymentModal.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PaymentModal(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      // GoRoute(
      //   name: RoutePath.paypal,
      //   path: RoutePath.paypal.addBasePath,
      //   parentNavigatorKey: _rootNavigatorKey,
      //   builder: (context, state) {
      //     final plan = state.extra as SubscriptionPlan?;
      //     if (plan == null) {
      //       return const Scaffold(
      //         body: Center(child: Text('No subscription plan provided')),
      //       );
      //     }
      //     return PaypalPage(plan: plan);
      //   },
      // ),

      ///======================= Auth Routes =======================
      GoRoute(
        name: RoutePath.adminSignUp,
        path: RoutePath.adminSignUp.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AdminSignUpScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.forgotPass,
        path: RoutePath.forgotPass.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.resetPassConfirm,
        path: RoutePath.resetPassConfirm.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PasswordResetConfirmScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.resetPass,
        path: RoutePath.resetPass.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SetPasswordScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.verification,
        path: RoutePath.verification.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CodeVerificationScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.resetPasswordSuccess,
        path: RoutePath.resetPasswordSuccess.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const UpdatePasswordSuccessScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.report,
        path: RoutePath.report.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ReportScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),

      GoRoute(
        name: RoutePath.errorScreen,
        path: RoutePath.errorScreen.addBasePath,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (ctx, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ErrorPage(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
    ],
  );

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static GoRouter get route => initRoute;
}
