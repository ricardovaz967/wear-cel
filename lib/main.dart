import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone/firebase_options.dart';
import 'package:wear/wear.dart';

import 'homepages.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  String? title = message.notification!.title;
  String? body = message.notification!.body;

  AwesomeNotifications().createNotification(content: NotificationContent(id: 123,
       channelKey: "call_channel",
       color: Colors.white,
       title: title,
       body: body,
       category: NotificationCategory.Call,
       wakeUpScreen: true,
       fullScreenIntent: true,
       autoDismissible: false,
       backgroundColor: Colors.orange
       ),
       actionButtons: [
        NotificationActionButton(key: "ACCEPT", label: "Accept Call",
        color: Colors.green,
        autoDismissible: true
        ),
        NotificationActionButton(key: "REJECT", label: "Reject Call",
        color: Colors.red,
        autoDismissible: true
        )
       ]
       
       );

}

Future<void> main() async{

  AwesomeNotifications().initialize(null, [
    NotificationChannel(channelKey: "call_channel",
      channelName: "Call Channel",
      channelDescription: "Channel of calling",
      defaultColor: Colors.redAccent,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone
    )
  ]);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyWidget());
}


class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return HomePage();
          },
        );
      },
    );
  }
}