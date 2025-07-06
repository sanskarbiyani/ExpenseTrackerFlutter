// Dart packages
// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/screens/auth.dart';
// My Files
import 'package:message_expense_tracker/screens/home.dart';
import 'package:message_expense_tracker/theme_details.dart';

void main() async {
  // if (kDebugMode) {
  //   debugPaintSizeEnabled = true;
  // }
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authProvider.notifier).tryAutoLogin();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: switch (state) {
        Authenticated _ => const HomeScreen(),
        UnAuthenticated _ => const AuthScreen(),
      },
    );
  }
}
