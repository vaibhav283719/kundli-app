import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/kundli/presentation/screens/birth_details_screen.dart';
import '../../features/kundli/presentation/screens/kundli_chart_screen.dart';
import '../../features/horoscope/presentation/screens/horoscope_screen.dart';
import '../../features/compatibility/presentation/screens/compatibility_screen.dart';
import '../../features/remedies/presentation/screens/remedies_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/premium/presentation/screens/premium_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/splash';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/birth-details',
        name: 'birth-details',
        builder: (context, state) => const BirthDetailsScreen(),
      ),
      GoRoute(
        path: '/kundli-chart',
        name: 'kundli-chart',
        builder: (context, state) => const KundliChartScreen(),
      ),
      GoRoute(
        path: '/horoscope',
        name: 'horoscope',
        builder: (context, state) => const HoroscopeScreen(),
      ),
      GoRoute(
        path: '/compatibility',
        name: 'compatibility',
        builder: (context, state) => const CompatibilityScreen(),
      ),
      GoRoute(
        path: '/remedies',
        name: 'remedies',
        builder: (context, state) => const RemediesScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) {
          final profileId = state.uri.queryParameters['id'];
          return EditProfileScreen(profileId: profileId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
