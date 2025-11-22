import 'package:flutter/material.dart';

class SettingsNotifier extends ChangeNotifier {
  bool _isDark = false;
  bool _notifications = true;
  int _volume = 50;

  bool get isDark => _isDark;
  bool get notifications => _notifications;
  int get volume => _volume;

  void setIsDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }

  void setVolume(int value) {
    _volume = value;
    notifyListeners();
  }

  /// Возвращаем true при успешном сохранении, false если валидация не прошла.
  Future<bool> saveSettings(String username, String email) async {
    if (!_isValidUsername(username) || !_isValidEmail(email)) {
      return false;
    }
    // Симуляция сетевого/дискового сохранения
    await Future.delayed(const Duration(seconds: 1));
    // После успешного сохранения можно уведомить слушателей (если нужно обновить состояние)
    notifyListeners();
    return true;
  }

  bool _isValidEmail(String email) => email.contains('@');
  bool _isValidUsername(String username) => username.isNotEmpty;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsNotifier settingsNotifier = SettingsNotifier();
  final TextEditingController usernameController = TextEditingController(text: "user123");
  final TextEditingController emailController = TextEditingController(text: "me@example.com");

  @override
  void initState() {
    super.initState();
    // Подписываемся, чтобы обновлять UI при изменениях в notifier
    settingsNotifier.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsNotifier.removeListener(_onSettingsChanged);
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(() {}); // простой способ обновить виджеты, которые читают settingsNotifier
  }

  Future<void> _handleSave() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    if (username.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username empty')));
      }
      return;
    }

    if (!email.contains('@')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bad email')));
      }
      return;
    }

    // Покажем индикатор загрузки в SnackBar (или лучше — отдельным индикатором)
    final scaffold = ScaffoldMessenger.of(context);
    final loading = scaffold.showSnackBar(
      const SnackBar(content: Text('Saving settings...'), duration: Duration(minutes: 1)),
    );

    final success = await settingsNotifier.saveSettings(usernameController.text, emailController.text);

    // убираем "loading" SnackBar
    loading.closed.then((_) {});

    scaffold.clearSnackBars();
    if (mounted) {
      scaffold.showSnackBar(SnackBar(content: Text(success ? 'Settings saved' : 'Failed to save settings')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // profile inputs
            _profileForms(),
            const SizedBox(height: 16),
            // toggles
            _toggles(),
            _notificationToggles(),
            const SizedBox(height: 12),
            // volume slider with magic number behavior
            _volumeSlider(),
            const SizedBox(height: 24),
            // save button
            _saveButton(),
            const SizedBox(height: 12),
            // debug info
            Text(
              'Debug: isDark=${settingsNotifier.isDark} notifications=${settingsNotifier.notifications} volume=${settingsNotifier.volume}',
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: _handleSave,
        child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Save settings')),
      ),
    );
  }

  Column _volumeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Volume'),
        Slider(
          value: settingsNotifier.volume.toDouble(),
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (val) {
            // Обновляем через notifier — UI обновится через listener -> setState
            settingsNotifier.setVolume(val.toInt());
          },
        ),
        Text('Current: ${settingsNotifier.volume}'),
      ],
    );
  }

  Row _notificationToggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Notifications'),
        Switch(
          value: settingsNotifier.notifications,
          onChanged: (v) {
            settingsNotifier.setNotifications(v);
            if (!v) {
              // Побочный эффект (можно перенести в notifier или отделить)
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications disabled')));
              }
            }
          },
        ),
      ],
    );
  }

  Row _toggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Dark mode'),
        Switch(
          value: settingsNotifier.isDark,
          onChanged: (v) {
            settingsNotifier.setIsDark(v);
          },
        ),
      ],
    );
  }

  Container _profileForms() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
    );
  }
}
