import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and conditions')),
      );
      return;
    }
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primarySaffron,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join Kundli App',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primarySaffron,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create your account to explore the cosmos',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    prefixIcon: Icons.person_outlined,
                    validator: Validators.validateName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
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
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    showPasswordToggle: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (v) => Validators.validateConfirmPassword(
                      v,
                      _passwordController.text,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleRegister(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                        activeColor: AppConstants.primarySaffron,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall,
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: AppConstants.primarySaffron,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppConstants.primarySaffron,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => CustomButton(
                      text: 'Create Account',
                      onPressed: _handleRegister,
                      isLoading: auth.isLoading,
                      useGradient: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Login',
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
    );
  }
}
