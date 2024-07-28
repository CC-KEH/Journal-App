import 'package:flutter/material.dart';
import 'package:journal/notifiers/settings_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journal/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:journal/notifications.dart';

class SettingsScreen extends StatefulWidget {
  final Function() onThemeChanged;

  const SettingsScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  bool _isGridView = false;
  bool _isNotificationsOn = true;
  bool _isTitleBelow = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      _isGridView = prefs.getBool('isGridView') ?? false;
      _isNotificationsOn = prefs.getBool('isNotificationsOn') ?? true;
      _isTitleBelow = prefs.getBool('isTitleBelow') ?? true;
    });
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
    await prefs.setBool('isGridView', _isGridView);
    await prefs.setBool('isNotificationsOn', _isNotificationsOn);
    await prefs.setBool('isTitleBelow', _isTitleBelow);
    widget.onThemeChanged(); // Notify theme change
  }

  _toggleTheme(bool value) {
    setState(() => _isDarkTheme = value);
    _savePreferences();

    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    if (_isDarkTheme) {
      themeNotifier.setDarkTheme();
    } else {
      themeNotifier.setLightTheme();
    }
  }

  _toggleView(bool value) {
    setState(() => _isGridView = value);
    _savePreferences();
  }

  _toggleNotifications(bool value) {
    setState(() => _isNotificationsOn = value);
    _savePreferences();
    if (_isNotificationsOn) {
      scheduleNotifications(); // Enable notifications
    } else {
      cancelNotifications(); // Disable notifications
    }
  }

  _toggleTitlePosition(bool value) {
    setState(() => _isTitleBelow = value);
    _savePreferences();
  }


  @override
  Widget build(BuildContext context) {
    const _verticalGap = SizedBox(height: 20);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Theme'),
                value: _isDarkTheme,
                onChanged: _toggleTheme,
              ),
              _verticalGap,
              SwitchListTile(
                title: const Text('Grid View'),
                value: _isGridView,
                onChanged: (value) {
                  settingsProvider.setViewChange(value);
                  setState(() => _isGridView = value);
                },
              ),
              _verticalGap,
              SwitchListTile(
                title: const Text('Notifications'),
                value: _isNotificationsOn,
                onChanged: _toggleNotifications,

              ),
              _verticalGap,
              SwitchListTile(
                title: const Text('Position title below the description'),
                value: _isTitleBelow,
                onChanged: (value) {
                  settingsProvider.setTitlePosition(value);
                  setState(() => _isTitleBelow = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
