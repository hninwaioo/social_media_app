import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/fcm/fcm_service.dart';
import 'package:social_media_app/models/authentication_model_impl.dart';
import 'package:social_media_app/pages/login_view_page.dart';
import 'package:social_media_app/pages/news_feed_home_view_page.dart';
import 'package:firebase_installations/firebase_installations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForMessages();
  var firebaseInstallationId = await FirebaseInstallations.id ?? 'Unknown installation id';
  debugPrint("Firebase Installation id =====> $firebaseInstallationId");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final _authenticationModel = AuthenticationModelImpl();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.ubuntu().fontFamily
      ),
      home: (_authenticationModel.isLoggedIn())
          ?
      NewsFeedHomeViewPage()
          :
      LoginViewPage()
    );
  }
}


