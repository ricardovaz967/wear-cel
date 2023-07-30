import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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

      AwesomeNotifications().actionStream.listen((event) {
        if(event.buttonKeyPressed=="REJECT"){
          print("Call rejected");
        } else if(event.buttonKeyPressed == "ACCEPT"){
          print("Call Accepted");
        }
        else {
          print("Clicked on notification");
        }
      });

    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async{
                  String? token = await FirebaseMessaging.instance.getToken();
                  print(token);
                },
                child: Container(
                  width: 90,
                  height: 40,
                  //padding: EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey
                  ),
                  child: const Center(child:  Text("Get token", style: TextStyle(color: Colors.white),)),
                ),
              ),
              InkWell(
                onTap: (){
                  sendAndroidNotification();
                },
                child: Container(
                  width: 90,
                  height: 40,
                  //padding: EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.blue
                  ),
      
                  child: const Center(child: Text("Send Push",  style: TextStyle(color: Colors.white))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendAndroidNotification() async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAARLCtfzE:APA91bGTZOrcbR2ckhp9HZpGAqE5hJ3idrHQFiTy4SkyL34NAwT2uLSXwqoaFjUDfrs7AQUxeGhsNFm_yLS5p94pCopDDx4pakxIzcy41Esvf1ILPKo3Yt8hgXizp06dekpkgWwIwx2g',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Ejemplo',
              'title': 'Nueva Solicitud',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': 'eT_aQYCARKeTq5_9lbBC6I:APA91bH8yX044pl1GqGfyZDzR-Yc-HsamXV4dvP1E8gaebcVAihABQt_pH-go_in0keaCb9w7qYVlup1JVH5OgQugLrJJttyVA0cL_tNtPb17x9z_xqOE_UOBbKz29sEZG9JeSHbzdMM',
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }
}