import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wingame/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splashscreen/splashscreen.dart' as prefix0;
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*theme: ThemeData(
        fontFamily: 'Montserrat'
      ),*/
      //home: LoginPage(),
      home: ShowSplash(),
    );
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
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        //margin: EdgeInsets.only( top: 40) ,
        child: prefix0.SplashScreen(
          seconds: 4,
          image: Image.asset("assets/wingame.gif",fit: BoxFit.fitWidth,alignment: Alignment.center,width: 200,),
          navigateAfterSeconds: LoginPage(),
          photoSize: MediaQuery.of(context).size.height * 0.30,
          loaderColor: HexColor(globals.color_pink),
          useLoader : true,
            loadingText:Text("Welcome To Wingame",style: TextStyle(color: Colors.white),),
            backgroundColor:HexColor(globals.color_background),

        )
    );
  }
}