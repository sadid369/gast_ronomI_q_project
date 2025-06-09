import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'core/routes/routes.dart';
import 'global/language/controller/language_controller.dart';
import 'utils/app_colors/app_colors.dart';
// Import your Language translations class

// your translations

late final List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cameras if needed, or do other async initialization here
  // cameras = await availableCameras();

  // Initialize LanguageController and load saved language
  final LanguageController languageController = Get.put(LanguageController());
  await languageController.getLanguageType();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    return ScreenUtilInit(
      //
      designSize: const Size(393, 852),
      builder: (_, __) {
        return Obx(() => GetMaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.backgroundColor,
                useMaterial3: true,
              ),
              translations: Language(), // your translations class
              locale: languageController.isEnglish.value
                  ? const Locale('en', 'US')
                  : const Locale('de', 'DE'),
              fallbackLocale: const Locale('en', 'US'),
              routeInformationParser: AppRouter.route.routeInformationParser,
              routerDelegate: AppRouter.route.routerDelegate,
              routeInformationProvider:
                  AppRouter.route.routeInformationProvider,
            ));
      },
    );
  }
}
