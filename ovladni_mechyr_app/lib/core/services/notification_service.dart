import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static int startDiaryId = 1;
  static int endDiaryId = 2;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // prepare android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // prepare iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init settigns
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // init plugin
    await notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "uzis_channel_id",
        "Uzis Notifications",
        channelDescription: "Uzis Notification Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    int id = 0,
    required DateTime selectedTime,
    required String title,
    String? body,
  }) async {
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(selectedTime, tz.local);

    try {
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print('Notification scheduled successfully');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<bool> isNotificationScheduled(int id) async {
    final pending = await notificationsPlugin.pendingNotificationRequests();
    return pending.any((notification) => notification.id == id);
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
