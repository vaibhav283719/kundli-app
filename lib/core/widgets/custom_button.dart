import 'package:flutter/material.dart';
import '../../config/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool useGradient;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.useGradient = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 52,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;

    if (isOutlined) {
      return SizedBox(
        width: effectiveWidth,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor ?? AppConstants.primarySaffron,
            side: BorderSide(
              color: backgroundColor ?? AppConstants.primarySaffron,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(context),
        ),
      );
    }

    if (useGradient) {
      return GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          width: effectiveWidth,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: onPressed == null
                  ? [Colors.grey.shade400, Colors.grey.shade300]
                  : [
                      AppConstants.primarySaffron,
                      const Color(0xFFFF9500),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: onPressed != null
                ? [
                    BoxShadow(
                      color: AppConstants.primarySaffron.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Center(child: _buildChild(context, isGradient: true)),
        ),
      );
    }

    return SizedBox(
      width: effectiveWidth,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppConstants.primarySaffron,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 4,
          shadowColor: (backgroundColor ?? AppConstants.primarySaffron)
              .withOpacity(0.4),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context, {bool isGradient = false}) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isGradient || !isOutlined ? Colors.white : AppConstants.primarySaffron,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: isGradient ? Colors.white : textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF2A0F4A) : Colors.white,
          side: BorderSide(
            color: isDark ? const Color(0xFF3D1A6B) : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(iconPath, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
