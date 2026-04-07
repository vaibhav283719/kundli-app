import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../config/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Appearance
              _SectionHeader(title: 'Appearance'),
              _SettingsCard(
                children: [
                  _ThemeSelector(
                    currentMode: settings.themeMode,
                    onChanged: settings.setThemeMode,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Language
              _SectionHeader(title: 'Language'),
              _SettingsCard(
                children: [
                  _LanguageSelector(
                    currentLocale: settings.locale,
                    onChanged: settings.setLocale,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Notifications
              _SectionHeader(title: 'Notifications'),
              _SettingsCard(
                children: [
                  _SwitchTile(
                    icon: Icons.wb_sunny_outlined,
                    title: 'Daily Horoscope',
                    subtitle: 'Get your daily rashifal notification',
                    value: settings.dailyHoroscopeNotification,
                    onChanged: settings.setDailyHoroscopeNotification,
                  ),
                  const Divider(height: 1),
                  _SwitchTile(
                    icon: Icons.access_time,
                    title: 'Auspicious Timings',
                    subtitle: 'Reminders for muhurta timings',
                    value: settings.auspiciousTimingNotification,
                    onChanged: settings.setAuspiciousTimingNotification,
                  ),
                  const Divider(height: 1),
                  _SwitchTile(
                    icon: Icons.celebration_outlined,
                    title: 'Festival Reminders',
                    subtitle: 'Hindu festivals and Ekadashi reminders',
                    value: settings.festivalReminders,
                    onChanged: settings.setFestivalReminders,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Premium
              GestureDetector(
                onTap: () => context.push('/premium'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF6B00)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text('👑', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upgrade to Premium',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Unlock all features and remove ads',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // About
              _SectionHeader(title: 'About'),
              _SettingsCard(
                children: [
                  _ListTile(
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  _ListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ListTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ListTile(
                    icon: Icons.star_outline,
                    title: 'Rate App',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _ListTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Logout
              Consumer<AuthProvider>(
                builder: (context, auth, _) => _SettingsCard(
                  children: [
                    _ListTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      titleColor: Colors.red,
                      onTap: () => _confirmLogout(context, auth),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Instant Kundli Maker v1.0.0',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Instant Kundli Maker',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6B00)]),
        ),
        child: const Center(
          child: Text('ॐ', style: TextStyle(fontSize: 24, color: Colors.white)),
        ),
      ),
      children: const [
        Text(
          'A comprehensive Vedic astrology app with Kundli generation, '
          'horoscope predictions, compatibility matching, and remedies.',
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              ctx.pop();
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppConstants.primarySaffron,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: children),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onChanged;

  const _ThemeSelector({
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, color: AppConstants.primarySaffron, size: 20),
              const SizedBox(width: 12),
              Text(
                'Theme',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ThemeOption(
                label: 'Light',
                icon: Icons.wb_sunny_outlined,
                isSelected: currentMode == ThemeMode.light,
                onTap: () => onChanged(ThemeMode.light),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'Dark',
                icon: Icons.nights_stay_outlined,
                isSelected: currentMode == ThemeMode.dark,
                onTap: () => onChanged(ThemeMode.dark),
              ),
              const SizedBox(width: 8),
              _ThemeOption(
                label: 'System',
                icon: Icons.phone_android,
                isSelected: currentMode == ThemeMode.system,
                onTap: () => onChanged(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.primarySaffron
                : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2A0F4A)
                    : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onChanged;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: AppConstants.primarySaffron, size: 20),
              const SizedBox(width: 12),
              Text('Language', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  label: 'English',
                  subLabel: 'English',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () => onChanged(const Locale('en', 'US')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _LanguageOption(
                  label: 'हिन्दी',
                  subLabel: 'Hindi',
                  isSelected: currentLocale.languageCode == 'hi',
                  onTap: () => onChanged(const Locale('hi', 'IN')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.subLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primarySaffron
              : (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A0F4A)
                  : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              subLabel,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppConstants.primarySaffron, size: 22),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppConstants.primarySaffron,
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  const _ListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppConstants.primarySaffron, size: 22),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: titleColor),
      ),
      trailing: titleColor == null
          ? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }
}
