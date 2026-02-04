import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =====================
          // PROFILE HEADER
          // =====================
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: dark ? Colors.white24 : Colors.black12,
                  backgroundImage: const AssetImage('assets/images/profile.jpg'),
                ),

                const SizedBox(height: 12),
                Text(
                  'Rendy Kamaluddin',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'NPM: 714230030',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),

          // =====================
          // ACCOUNT SECTION
          // =====================
          _sectionTitle(context, 'Account'),
          _settingTile(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Informasi pribadi',
            onTap: () {},
          ),
          _settingTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'email@student.ac.id',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // =====================
          // APPEARANCE SECTION
          // =====================
          _sectionTitle(context, 'Appearance'),
          Obx(
            () => _themeTile(
              context,
              title: 'Theme',
              value: controller.themeMode.value,
              onChanged: (mode) {
                if (mode != null) {
                  controller.changeTheme(mode);
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          // =====================
          // ABOUT SECTION
          // =====================
          _sectionTitle(context, 'About'),
          _settingTile(
            icon: Icons.info_outline,
            title: 'About Todpo',
            subtitle: 'Productivity App',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Todpo',
                applicationVersion: '1.0.0',
                children: [
                  const Text(
                    'Todpo adalah aplikasi manajemen tugas '
                    'dan pomodoro untuk meningkatkan produktivitas.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // =====================
  // REUSABLE WIDGETS
  // =====================

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _themeTile(
    BuildContext context, {
    required String title,
    required ThemeMode value,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(title),
      subtitle: Text(value.name),
      trailing: DropdownButton<ThemeMode>(
        value: value,
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
        ],
      ),
    );
  }
}
