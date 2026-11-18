import 'package:flutter/material.dart';
import 'package:smarthome/ui/widgets/appbar.dart';

import './loginForm.dart';
import 'registerForm.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 850;

            if (isDesktop) {
              return Row(
                children: [
                  Expanded(child: _buildWelcomePanel(context)),
                  Expanded(child: _buildAuthPanel(context, isDesktop: true)),
                ],
              );
            }

            return Container(
              width: double.infinity,
              color: colors.surface,
              child: _buildAuthPanel(context, isDesktop: false),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomePanel(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primaryContainer,
            colors.surfaceContainerHighest,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'NEXA',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.home_work_rounded, size: 90, color: colors.onPrimary),

              const SizedBox(height: 32),

              Text(
                'Smart Living,\nSimplified.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Take control of your home. '
                'Manage your devices, monitor your environment '
                'and enjoy a smarter lifestyle.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
            ],
          ),

          Text(
            'YOUR HOME. YOUR CONTROL.',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.onPrimary,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthPanel(BuildContext context, {required bool isDesktop}) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 24,
          vertical: 32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isDesktop) ...[
                Text(
                  'NEXA',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 32),
              ],

              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Login'),
                    icon: Icon(Icons.login_rounded),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Register'),
                    icon: Icon(Icons.person_add_alt_1_rounded),
                  ),
                ],
                selected: {_isLogin},
                onSelectionChanged: (selection) {
                  setState(() {
                    _isLogin = selection.first;
                  });
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.03, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child:
                    _isLogin
                        ? const LoginForm(key: ValueKey('login'))
                        : const RegisterForm(key: ValueKey('register')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
