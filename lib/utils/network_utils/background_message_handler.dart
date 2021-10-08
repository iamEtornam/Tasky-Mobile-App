import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.


  if (message.notification != null) {
    // Handle notification message
    final RemoteNotification notification = message.notification!;
    _logger.d(notification.title);
  }
}
