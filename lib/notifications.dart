import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotifications() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Good Morning!',
    '',
    _nextInstanceOfTime(7, 0),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'morning_channel_id',
        'Morning Notifications',
        channelDescription: 'Channel for morning notifications',
      ),
    ),
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.time,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Did you have lunch?',
    '',
    _nextInstanceOfTime(14, 0),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'afternoon_channel_id',
        'Afternoon Notifications',
        channelDescription: 'Channel for afternoon notifications',
      ),
    ),
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.time,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    2,
    'How did your day go? Please share with me.',
    '',
    _nextInstanceOfTime(21, 0),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'night_channel_id',
        'Night Notifications',
        channelDescription: 'Channel for night notifications',
      ),
    ),
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.time,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

void configureTimeZone() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
}

void cancelNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
