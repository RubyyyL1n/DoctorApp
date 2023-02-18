import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initalize() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@drawable/ic_stat_access_alarms');

    final InitializationSettings settings = InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );

  }

  Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
      return NotificationDetails(android: androidNotificationDetails);
    }

    Future<void> showNotification(
      {
         required int id,
         required String title,
         required String body,
      }
    ) async {
      final details = await notificationDetails();
      await _localNotificationService.show(id, title, body, details);
    }

    void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    

  void onSelectNotification(String? payload) {
    print('payload $payload');
  }
}

}