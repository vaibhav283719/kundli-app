import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late TabController _tabController;
  bool _isEmailTab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _isEmailTab = _tabController.index == 0);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final identifier =
        _isEmailTab ? _emailController.text.trim() : _phoneController.text.trim();
    final success = await authProvider.login(identifier, _passwordController.text);
    if (success && mounted) {
      context.go('/home');
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A0533), const Color(0xFF0D0221)]
                : [const Color(0xFFFFF8F0), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height - MediaQuery.of(context).padding.top),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primarySaffron.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('ॐ', style: TextStyle(fontSize: 40, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primarySaffron,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue your cosmic journey',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tab bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A0F4A) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppConstants.primarySaffron,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        dividerColor: Colors.transparent,
                        tabs: const [Tab(text: 'Email'), Tab(text: 'Phone')],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_isEmailTab)
                            CustomTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: Validators.validateEmail,
                              textInputAction: TextInputAction.next,
                            )
                          else
                            CustomTextField(
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                              validator: Validators.validatePhone,
                              textInputAction: TextInputAction.next,
                            ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: true,
                            showPasswordToggle: true,
                            prefixIcon: Icons.lock_outlined,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Password is required'
                                : null,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push('/forgot-password'),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppConstants.primarySaffron,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => CustomButton(
                              text: 'Login',
                              onPressed: _handleLogin,
                              isLoading: auth.isLoading,
                              useGradient: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Social buttons
                    SocialLoginButton(
                      text: 'Sign in with Google',
                      iconPath: '🔵',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google sign-in coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SocialLoginButton(
                      text: 'Sign in with Facebook',
                      iconPath: '🔷',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Facebook sign-in coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: AppConstants.primarySaffron,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
