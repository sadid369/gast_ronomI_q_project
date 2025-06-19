import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';
import 'controller/scan_controller.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ScanController ctrl = ScanController();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Top bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Text(
                        AppStrings.scanner,
                        style: AppStyle.kohSantepheap16w700C3F3F3F,
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                ),
                // Image preview
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: AppColors.backgroundColor,
                            ),
                            child: ctrl.pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.zero,
                                    child: Image.file(
                                      ctrl.pickedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : Container(),
                          ),
                          // Corner borders (same as before)
                          Positioned(
                            top: 24,
                            left: 24,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                  left: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 24,
                            right: 24,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                  right: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            left: 24,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                  left: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            right: 24,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                  right: BorderSide(
                                      color: Colors.grey.shade600, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom Controls bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: AppColors.backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: ctrl.isLoading
                            ? null
                            : () => ctrl.takePicture(context),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  ctrl.isLoading ? Colors.grey : Colors.black54,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: const Icon(Icons.photo_library_outlined),
                        onPressed: ctrl.isLoading
                            ? null
                            : () => ctrl.pickImage(context),
                        color: ctrl.isLoading ? Colors.grey : Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // full-screen loading overlay
        if (ctrl.isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Center(
                  child: Lottie.asset(
                    "assets/animation/working.json",
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
