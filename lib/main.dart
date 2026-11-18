import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/core/theme/darkTheme.dart';
import 'package:smarthome/core/theme/lightTheme.dart';
import 'package:smarthome/features/providers/themeprovider.dart';
import 'package:smarthome/ui/auth/authUI.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خونه آقاجون',

      theme: AppLightTheme.theme,
      darkTheme: AppDarkTheme.theme,
      themeMode: themeMode,

      home: const AuthPage(),
    );
  }
}
