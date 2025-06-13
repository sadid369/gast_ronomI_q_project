import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routes/route_path.dart';
import '../core/routes/routes.dart';
import '../helper/tost_message/show_snackbar.dart';

void checkApi({
  required Response response,
  BuildContext? context,
}) async {
  if (response.statusCode == 401) {
    AppRouter.route.replaceNamed(RoutePath.login);
  } else if (response.statusCode == 503 && context != null) {
    showSnackBar(
      context: context,
      content: response.statusText ?? "No internet connection",
    );
  } else if (context != null) {
    showSnackBar(
      context: context,
      content: response.bodyString!,
    );
  }
}
