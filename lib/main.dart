// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:groc_shopy/utils/static_strings/static_strings.dart';
// import 'core/routes/routes.dart';
// import 'dependency_injection/getx_injection.dart';
// import 'dependency_injection/path.dart';
// import 'global/language/controller/language_controller.dart';
// import 'utils/app_colors/app_colors.dart';
// import "package:purchases_flutter/purchases_flutter.dart";
// import "package:purchases_ui_flutter/purchases_ui_flutter.dart";
// // Import your Language translations class
// // Android Account: nicklasbaeumer@googlemail.com PW: temporaryPW1616
// // Apple Account: nicklasbaeumer1@googlemail.com PW: temporaryPW1616
// // renevue cat email: nicklasbaeumer@googlemail.com
// // PW: temporaryPW1616
// // your translations

// late final List<CameraDescription> cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initDependencies();
//   initGetx();
//   // Stripe.publishableKey =
//   //     'pk_test_51QvcVcH5cscgBQuXnttFXi0clmPxZZqTQXW8GglPJFHSoOw59eSJYhguuPw6vvFsxx7Sti0CLDiLKkOJoeKn7Bi9002MxBwL47';
//   // await Stripe.instance.applySettings();
//   final LanguageController languageController = Get.put(LanguageController());
//   await languageController.getLanguageType();
//   runApp(const MyApp());
//   await _configureSDK();
// }

// Future<void> _configureSDK() async {
//   await Purchases.setLogLevel(LogLevel.debug);
//   PurchasesConfiguration? configuration;
//   if (Platform.isIOS) {
//     configuration = PurchasesConfiguration('appl_tgMocwDrcPGwGMHVewMJRQgGKIw');
//   }
//   if (configuration == null) {
//     await Purchases.configure(configuration!);
//   }
//   final paywallResult = await RevenueCatUI.presentPaywallIfNeeded('pro');
//   log("Paywall result: $paywallResult");
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final LanguageController languageController = Get.find();

//     return ScreenUtilInit(
//       //
//       designSize: const Size(393, 852),
//       builder: (_, __) {
//         return Obx(
//           () => GetMaterialApp.router(
//             debugShowCheckedModeBanner: false,
//             title: AppStrings.appName,
//             theme: ThemeData(
//               scaffoldBackgroundColor: AppColors.backgroundColor,
//               useMaterial3: true,
//             ),
//             translations: Language(), // your translations class
//             locale: languageController.isEnglish.value
//                 ? const Locale('en', 'US')
//                 : const Locale('de', 'DE'),
//             fallbackLocale: const Locale('en', 'US'),
//             routeInformationParser: AppRouter.route.routeInformationParser,
//             routerDelegate: AppRouter.route.routerDelegate,
//             routeInformationProvider: AppRouter.route.routeInformationProvider,
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'core/routes/routes.dart';
import 'dependency_injection/getx_injection.dart';
import 'dependency_injection/path.dart';
import 'global/language/controller/language_controller.dart';
import 'utils/app_colors/app_colors.dart';
import "package:purchases_flutter/purchases_flutter.dart";
import "package:purchases_ui_flutter/purchases_ui_flutter.dart";

late final List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  initGetx();

  // Stripe.publishableKey =
  //     'pk_test_51QvcVcH5cscgBQuXnttFXi0clmPxZZqTQXW8GglPJFHSoOw59eSJYhguuPw6vvFsxx7Sti0CLDiLKkOJoeKn7Bi9002MxBwL47';
  // await Stripe.instance.applySettings();

  final LanguageController languageController = Get.put(LanguageController());
  await languageController.getLanguageType();

  // Configure RevenueCat BEFORE runApp
  await _configureSDK();

  runApp(const MyApp());
}

Future<void> _configureSDK() async {
  try {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;

    if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration('appl_tgMocwDrcPGwGMHVewMJRQgGKIw');
    } else if (Platform.isAndroid) {
      // Add your Android/Google Play API key here
      // configuration = PurchasesConfiguration('goog_YOUR_ANDROID_KEY_HERE');
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
      log("RevenueCat configured successfully");

      // Optional: Present paywall after configuration
      // Move this to where you actually want to show the paywall in your app
      // try {
      //   final paywallResult = await RevenueCatUI.presentPaywallIfNeeded('pro');
      //   log("Paywall result: $paywallResult");
      //   //log error if paywall fails
      //   log("Paywall result: ${paywallResult}. If you see an error, check your RevenueCat setup.");
      // } catch (e) {
      //   print(e);
      // }
      // sandbox abdullah.muhtasim@gmail.com pass: Bad123456
    } else {
      log("RevenueCat configuration failed: Unsupported platform");
    }
  } catch (e) {
    log("Error configuring RevenueCat: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (_, __) {
        return Obx(
          () => GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundColor,
              useMaterial3: true,
            ),
            translations: Language(),
            locale: languageController.isEnglish.value
                ? const Locale('en', 'US')
                : const Locale('de', 'DE'),
            fallbackLocale: const Locale('en', 'US'),
            routeInformationParser: AppRouter.route.routeInformationParser,
            routerDelegate: AppRouter.route.routerDelegate,
            routeInformationProvider: AppRouter.route.routeInformationProvider,
          ),
        );
      },
    );
  }
}
