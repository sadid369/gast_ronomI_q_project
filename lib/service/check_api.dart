import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:convert';

import '../core/routes/route_path.dart';
import '../core/routes/routes.dart';
import '../utils/static_strings/static_strings.dart';

void checkApi({
  required Response response,
  BuildContext? context,
}) async {
  if (response.statusCode == 401) {
    // Unauthorized - redirect to login
    if (context != null) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message: "Session expired. Please login again.",
        contentType: ContentType.failure,
      );
    }
    AppRouter.route.replaceNamed(RoutePath.login);
  } else if (response.statusCode == 503) {
    // Service unavailable
    if (context != null) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message: response.statusText ?? "Service temporarily unavailable",
        contentType: ContentType.failure,
      );
    }
  } else if (response.statusCode == 404) {
    // Not found
    if (context != null) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message: "Resource not found",
        contentType: ContentType.failure,
      );
    }
  } else if (response.statusCode == 500) {
    // Internal server error
    if (context != null) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message: "Internal server error. Please try again later.",
        contentType: ContentType.failure,
      );
    }
  } else if (response.statusCode == 400) {
    // Bad request - try to extract meaningful error message
    if (context != null) {
      String errorMessage = _extractErrorMessage(response);
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: errorMessage,
        contentType: ContentType.warning,
      );
    }
  } else if (response.statusCode == 422) {
    // Validation error
    if (context != null) {
      String errorMessage = _extractValidationErrors(response);
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: errorMessage,
        contentType: ContentType.warning,
      );
    }
  } else if (response.statusCode == 403) {
    // Forbidden
    if (context != null) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message:
            "Access denied. You don't have permission to perform this action.",
        contentType: ContentType.failure,
      );
    }
  } else if (response.statusCode != null &&
      response.statusCode! >= 400 &&
      context != null) {
    // Generic error for other 4xx and 5xx errors
    String errorMessage = _extractErrorMessage(response);
    _showAwesomeSnackbar(
      context,
      title: AppStrings.error.tr,
      message: errorMessage.isNotEmpty
          ? errorMessage
          : "Something went wrong. Please try again.",
      contentType: ContentType.failure,
    );
  }
}

// Helper method to show awesome snackbar
void _showAwesomeSnackbar(
  BuildContext context, {
  required String title,
  required String message,
  required ContentType contentType,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// Helper method to extract error message from response
String _extractErrorMessage(Response response) {
  try {
    if (response.body != null) {
      // Try to parse as JSON first
      if (response.body is Map<String, dynamic>) {
        final body = response.body as Map<String, dynamic>;

        // Common error message fields
        if (body.containsKey('message')) {
          return body['message'].toString();
        } else if (body.containsKey('error')) {
          return body['error'].toString();
        } else if (body.containsKey('detail')) {
          return body['detail'].toString();
        } else if (body.containsKey('errors')) {
          return body['errors'].toString();
        }
      } else if (response.body is String) {
        // Try to parse string as JSON
        try {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          if (jsonBody.containsKey('message')) {
            return jsonBody['message'].toString();
          } else if (jsonBody.containsKey('error')) {
            return jsonBody['error'].toString();
          } else if (jsonBody.containsKey('detail')) {
            return jsonBody['detail'].toString();
          }
        } catch (e) {
          // If not valid JSON, return the string as is
          return response.body.toString();
        }
      }

      // Fallback to bodyString
      return response.bodyString ??
          response.statusText ??
          "Unknown error occurred";
    }

    return response.statusText ?? "Unknown error occurred";
  } catch (e) {
    return response.statusText ?? "Unknown error occurred";
  }
}

// Helper method to extract validation errors specifically
String _extractValidationErrors(Response response) {
  try {
    if (response.body != null && response.body is Map<String, dynamic>) {
      final body = response.body as Map<String, dynamic>;

      // Handle Laravel-style validation errors
      if (body.containsKey('errors') && body['errors'] is Map) {
        final errors = body['errors'] as Map<String, dynamic>;
        List<String> errorMessages = [];

        errors.forEach((field, messages) {
          if (messages is List) {
            errorMessages.addAll(messages.map((msg) => msg.toString()));
          } else {
            errorMessages.add(messages.toString());
          }
        });

        return errorMessages.join('\n');
      }

      // Handle other validation error formats
      if (body.containsKey('message')) {
        return body['message'].toString();
      }
    }

    return _extractErrorMessage(response);
  } catch (e) {
    return _extractErrorMessage(response);
  }
}

// Optional: Method for showing success messages
void showSuccessMessage(
  BuildContext context, {
  required String title,
  required String message,
}) {
  _showAwesomeSnackbar(
    context,
    title: title,
    message: message,
    contentType: ContentType.success,
  );
}

// Optional: Method for showing warning messages
void showWarningMessage(
  BuildContext context, {
  required String title,
  required String message,
}) {
  _showAwesomeSnackbar(
    context,
    title: title,
    message: message,
    contentType: ContentType.warning,
  );
}

// Optional: Method for showing info messages
void showInfoMessage(
  BuildContext context, {
  required String title,
  required String message,
}) {
  _showAwesomeSnackbar(
    context,
    title: title,
    message: message,
    contentType: ContentType.help,
  );
}
