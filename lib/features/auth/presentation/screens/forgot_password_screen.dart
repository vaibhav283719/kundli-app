import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../../config/constants/app_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendPasswordResetEmail(
      _emailController.text.trim(),
    );
    if (mounted) {
      if (success) {
        setState(() => _emailSent = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset email. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _emailSent ? _buildSuccessState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.primarySaffron.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset,
                color: AppConstants.primarySaffron,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primarySaffron,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No worries! Enter your email and we'll send you a password reset link.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: Validators.validateEmail,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleReset(),
          ),
          const SizedBox(height: 24),
          Consumer<AuthProvider>(
            builder: (context, auth, _) => CustomButton(
              text: 'Send Reset Link',
              onPressed: _handleReset,
              isLoading: auth.isLoading,
              useGradient: true,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Back to Login',
                    style: TextStyle(color: AppConstants.primarySaffron),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF00C853),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 56,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Email Sent!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primarySaffron,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We have sent a password reset link to\n${_emailController.text}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Back to Login',
          onPressed: () => context.go('/login'),
          useGradient: true,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _handleReset,
          child: Text(
            'Resend Email',
            style: TextStyle(color: AppConstants.primarySaffron),
          ),
        ),
      ],
    );
  }
}
