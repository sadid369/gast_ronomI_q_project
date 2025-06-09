// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../core/routes/route_path.dart';
// import '../../../utils/app_colors/app_colors.dart';
// import '../../../utils/static_strings/static_strings.dart';
// import '../../../utils/text_style/text_style.dart';

// class ScanScreen extends StatefulWidget {
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   final borderColor = Colors.grey.shade600;
//   final borderThickness = 2.0;

//   File? _pickedImage;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final imageFile = File(pickedFile.path);
//       setState(() {
//         _pickedImage = imageFile;
//       });

//       context.pushNamed(
//         RoutePath.scannedItemsScreen,
//         extra: imageFile,
//       );
//     }
//   }

//   Future<void> _takePicture() async {
//     final XFile? capturedFile =
//         await _picker.pickImage(source: ImageSource.camera);
//     if (capturedFile != null) {
//       final imageFile = File(capturedFile.path);
//       setState(() {
//         _pickedImage = imageFile;
//       });

//       context.pushNamed(
//         RoutePath.scannedItemsScreen,
//         extra: imageFile,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Custom Top Bar (like AppBar)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               color: AppColors.backgroundColor,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       context.pop();
//                     },
//                     child: Image.asset(
//                       Assets.icons.arrowBackGrey.path,
//                     ),
//                   ),
//                   Text(
//                     AppStrings.scanner,
//                     style: AppStyle.kohSantepheap16w700C3F3F3F,
//                   ),
//                   const Icon(Icons.more_horiz, color: Colors.grey),
//                 ],
//               ),
//             ),

//             // Expanded image + scanning UI area
//             Expanded(
//               child: Center(
//                 child: AspectRatio(
//                   aspectRatio: 1,
//                   child: Stack(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.all(24),
//                         decoration: const BoxDecoration(
//                           color: AppColors.backgroundColor,
//                         ),
//                         child: _pickedImage != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(0),
//                                 child: Image.file(
//                                   _pickedImage!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                 ),
//                               )
//                             : Container(), // empty container if no image
//                       ),

//                       // Corner borders
//                       Positioned(
//                         top: 24,
//                         left: 24,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             border: Border(
//                               top: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                               left: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 24,
//                         right: 24,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             border: Border(
//                               top: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                               right: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 24,
//                         left: 24,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                               left: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 24,
//                         right: 24,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                               right: BorderSide(
//                                   color: borderColor, width: borderThickness),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Bottom Controls bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               color: AppColors.backgroundColor,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(width: 32),
//                   GestureDetector(
//                     onTap: _takePicture,
//                     child: Container(
//                       width: 72,
//                       height: 72,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.black54, width: 4),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 32),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library_outlined),
//                     onPressed: _pickImage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart'; // <-- for .tr
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final borderColor = Colors.grey.shade600;
  final borderThickness = 2.0;

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _pickedImage = imageFile;
      });

      context.pushNamed(
        RoutePath.scannedItemsScreen,
        extra: imageFile,
      );
    }
  }

  Future<void> _takePicture() async {
    final XFile? capturedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      final imageFile = File(capturedFile.path);
      setState(() {
        _pickedImage = imageFile;
      });

      context.pushNamed(
        RoutePath.scannedItemsScreen,
        extra: imageFile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top Bar (like AppBar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     context.pop();
                  //   },
                  //   child: Image.asset(
                  //     Assets.icons.arrowBackGrey.path,
                  //   ),
                  // ),
                  SizedBox(),
                  Text(
                    AppStrings.scanner.tr,
                    style: AppStyle.kohSantepheap16w700C3F3F3F,
                  ),
                  const Icon(Icons.more_horiz, color: Colors.grey),
                ],
              ),
            ),

            // Expanded image + scanning UI area
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
                        child: _pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Container(), // empty container if no image
                      ),

                      // Corner borders
                      Positioned(
                        top: 24,
                        left: 24,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: borderColor, width: borderThickness),
                              left: BorderSide(
                                  color: borderColor, width: borderThickness),
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
                                  color: borderColor, width: borderThickness),
                              right: BorderSide(
                                  color: borderColor, width: borderThickness),
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
                                  color: borderColor, width: borderThickness),
                              left: BorderSide(
                                  color: borderColor, width: borderThickness),
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
                                  color: borderColor, width: borderThickness),
                              right: BorderSide(
                                  color: borderColor, width: borderThickness),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: AppColors.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black54, width: 4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
