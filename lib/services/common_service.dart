import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';

import '../providers/auth.dart';

class CommonService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static BuildContext? get context => navigatorKey.currentContext;

  static void showSnackBar(String text) {
    final ctx = context;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            text,
            style: TextStyle(
              color: Theme.of(ctx).colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: Theme.of(ctx).colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  static String getToken(WidgetRef ref) {
    final authState = ref.read(authProvider);
    if (authState is UnAuthenticated) {
      return "";
    }
    final appToken = (authState as Authenticated).accessToken;
    return appToken;
  }
}
