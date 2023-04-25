import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wingame/pages/login_page.dart';
import 'common/api_service.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart' as prefix0;
import 'dart:async';
import 'package:wingame/globalvar.dart' as globals;
/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp(name: "livegames",options: DefaultFirebaseOptions.currentPlatform);
  //print('Handling a background message ${message.messageId}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  RemoteNotification? notification = message.notification;
  Mynotification().shownotification(notification);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //if (!kIsWeb) {
  channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //}
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler,);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //print(message);
    RemoteNotification? notification = message.notification;
    Mynotification().shownotification(notification);
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  late Stream<String> _tokenStream;
  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    //FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    initialization();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        //For Notification Payload
        RemoteNotification? notification = message.notification;
        Mynotification().shownotification(notification);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print(message);
      RemoteNotification? notification = message.notification;
      Mynotification().shownotification(notification);
    });

    FirebaseMessaging.instance
        .getToken(
        vapidKey:
        'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    FirebaseMessaging.instance.subscribeToTopic("MainNotification");
    FirebaseMessaging.instance.subscribeToTopic("StarLineNotification");
    FirebaseMessaging.instance.subscribeToTopic("SuperJodiNotification");
  }

  @override
  Widget build(BuildContext context) {

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   /*theme: ThemeData(
    //     fontFamily: 'Montserrat'
    //   ),*/
    //   //home: LoginPage(),
    //   home: ShowSplash(),
    // );

    // if(appVersion=="1.0" && appVersion!="")
    // {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        /*theme: ThemeData(
        fontFamily: 'Montserrat'
      ),*/
        home: ShowSplash(),
      );
    // }
    // else
    // {
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: show_update_app_dialog(context),
    //   );
    // }
  }

  Future<void> setToken(String? token) async {
    //print('FCM Token: $token');
    setState(() {
      _token = token;
      globals.firebase_token = token;
    });
    await FirebaseMessaging.instance.subscribeToTopic("MainNotification");
    await FirebaseMessaging.instance.subscribeToTopic("StarLineNotification");
    await FirebaseMessaging.instance.subscribeToTopic("SuperJodiNotification");
  }

}

class Mynotification
{
  shownotification(notification)
  {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

class ShowSplash extends StatefulWidget {
  const ShowSplash({Key? key}) : super(key: key);

  @override
  State<ShowSplash> createState() => _ShowSplashState();
}

class _ShowSplashState extends State<ShowSplash> {

  String appVersion = "";
  String downloadUrl = "";
  String updateMsg = "";

  @override
  Widget build(BuildContext context) {
    APIService apiService = new APIService();
    apiService.apicall_getdata("appversion_check_flutter").then((value) {
      Map<String, dynamic> responseJson = json.decode(value);
      print(responseJson);
      setState(() {
        appVersion = responseJson["Appversion"];
        downloadUrl = responseJson["url"];
        updateMsg = responseJson["msg"];
      });
    });

    return Container(
        color: Colors.white,
        //margin: EdgeInsets.only( top: 40) ,
        child: prefix0.EasySplashScreen(
          durationInSeconds: 4,
          logo: Image.asset("assets/wingame.gif",fit: BoxFit.fitWidth,alignment: Alignment.center,width: 200,),
          navigator: (appVersion=="1.0") ? LoginPage() : show_update_app_dialog(context),
          logoWidth: MediaQuery.of(context).size.height * 0.30,
          loaderColor: HexColor(globals.color_pink),
          showLoader : true,
          loadingText:const Text("Welcome To Wingame",style: TextStyle(color: Colors.white),),
          backgroundColor:HexColor(globals.color_background),

        )
    );
  }

  @override
  Widget show_update_app_dialog(BuildContext context) {

    return Dialog(
      backgroundColor: HexColor(globals.color_background),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        decoration: BoxDecoration(
            color: HexColor(globals.color_background),
            borderRadius: BorderRadius.circular(20.0),      // Radius of the border
            border: Border.all(
              color: HexColor(globals.color_blue),
              width: 3,
              // Color of the border
            )
        ),
        height: 350,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("New App Version Found",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
                SizedBox(height: 20,),
                Text(updateMsg,style: TextStyle(color: Colors.white70),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      //style : ThemeHelper().filled_square_button(),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent),side: MaterialStateProperty.all(BorderSide(color: HexColor(globals.color_pink)))),
                        onPressed: () async {
                          String url = downloadUrl;
                          _launchInBrowser(Uri.parse(url));
                        }, child: Text("Download"))
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
  Future<void> _launchInBrowser(Uri url) async {
    final Uri toLaunch = Uri.parse(url.toString());
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $toLaunch';
    }
  }
}
