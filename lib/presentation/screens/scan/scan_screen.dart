import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  bool _isLoading = false;

  // API endpoints
  final String _scanReceiptUrl =
      'http://10.0.70.145:8001/receipt/scan-receipt/';

  // Update the _processAndNavigate method

  Future<void> _processAndNavigate(File imageFile) async {
    setState(() {
      _pickedImage = imageFile;
      _isLoading = true;
    });

    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_scanReceiptUrl));

      // Add authorization header
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTMwMjEwLCJpYXQiOjE3NDk5MzgyMTAsImp0aSI6ImNkZmQwZjE4Yjg5OTQ0OGM4YzY1ZWFiOTZhZGUxZjJmIiwidXNlcl9pZCI6MjZ9.RtRRXxJSqzdjQSyxQJ1N4uoPgoNm2Ms1okC8qFMWoBU';

      // Add file to request - IMPORTANT: field name is "receipt", not "file"
      final fileField = await http.MultipartFile.fromPath(
        'receipt', // Correct field name from API documentation
        imageFile.path,
        filename: 'receipt_image.jpg',
      );
      request.files.add(fileField);

      // For debugging
      print('Sending request to $_scanReceiptUrl');
      print('Headers: ${request.headers}');
      print('File exists: ${await File(imageFile.path).exists()}');
      print('File size: ${await File(imageFile.path).length()} bytes');

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 201) {
        // On success, navigate to scanned items screen
        if (mounted) {
          context.pushNamed(
            RoutePath.scannedItemsScreen,
            extra: {
              'image': imageFile,
              'scanSuccess': true,
              'apiResponse':
                  responseBody, // Add API response in case you need it
            },
          );
        }
      } else {
        // Handle error
        _showErrorDialog(
            'Failed to process receipt: ${response.statusCode}\n$responseBody');
      }
    } catch (e) {
      print('Error in upload: $e');
      _showErrorDialog('Error uploading image: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    print('Error: $message');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _processAndNavigate(imageFile);
    }
  }

  Future<void> _takePicture() async {
    final XFile? capturedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      final imageFile = File(capturedFile.path);
      await _processAndNavigate(imageFile);
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
                  const SizedBox(),
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
              child: Stack(
                children: [
                  // Scanner UI
                  Center(
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
                                : Container(),
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
                                      color: borderColor,
                                      width: borderThickness),
                                  left: BorderSide(
                                      color: borderColor,
                                      width: borderThickness),
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
                                      color: borderColor,
                                      width: borderThickness),
                                  right: BorderSide(
                                      color: borderColor,
                                      width: borderThickness),
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
                                      color: borderColor,
                                      width: borderThickness),
                                  left: BorderSide(
                                      color: borderColor,
                                      width: borderThickness),
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
                                      color: borderColor,
                                      width: borderThickness),
                                  right: BorderSide(
                                      color: borderColor,
                                      width: borderThickness),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading overlay
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.yellowFFD673),
                        ),
                      ),
                    ),
                ],
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
                    onTap: _isLoading ? null : _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isLoading ? Colors.grey : Colors.black54,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined),
                    onPressed: _isLoading ? null : _pickImage,
                    color: _isLoading ? Colors.grey : Colors.black,
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
