import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../config/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _rotateAnim = Tween<double>(begin: -0.5, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthState();

    if (!mounted) return;
    if (authProvider.isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0533),
              Color(0xFF0D0221),
              Color(0xFF1A0533),
            ],
            stops: [0, 0.5, 1],
          ),
        ),
        child: Stack(
          children: [
            // Decorative stars
            ..._buildStars(),
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _scaleAnim.value,
                        child: Transform.rotate(
                          angle: _rotateAnim.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFF6B00),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.primarySaffron.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'ॐ',
                                style: TextStyle(
                                  fontSize: 64,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFF6B00),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'Kundli App',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your Vedic Astrology Guide',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Bottom loading indicator
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF6B00)),
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading cosmic data...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    return [
      _star(top: 80, left: 40, size: 4),
      _star(top: 120, right: 60, size: 6),
      _star(top: 200, left: 80, size: 3),
      _star(top: 300, right: 30, size: 5),
      _star(top: 400, left: 20, size: 4),
      _star(bottom: 200, right: 80, size: 6),
      _star(bottom: 150, left: 100, size: 4),
      _star(bottom: 300, right: 120, size: 3),
    ];
  }

  Widget _star({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double size = 4,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _fadeAnim,
        builder: (context, _) => Opacity(
          opacity: (_fadeAnim.value * 0.8).clamp(0.0, 1.0),
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
