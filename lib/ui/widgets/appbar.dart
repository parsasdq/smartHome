import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/features/providers/themeprovider.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: const Text('خونه آقاجون'),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(child: buildThemeToggle(context, ref, isDark)),
        ),
      ],
    );
  }

  Widget buildThemeToggle(BuildContext context, WidgetRef ref, bool isDark) {
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).toggle(isDark: isDark);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 76,
        height: 38,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF172554) : const Color(0xFFFFD54F),
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 350),
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF263B73) : const Color(0xFFFFF3CD),
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                key: ValueKey(isDark),
                size: 20,
                color: isDark ? Colors.white : const Color(0xFFFF9800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
