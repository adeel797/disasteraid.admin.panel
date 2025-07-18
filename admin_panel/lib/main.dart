import 'package:admin_panel/providers/auth_provider.dart';
import 'package:admin_panel/providers/edit_user_provider.dart';
import 'package:admin_panel/providers/homepage_provider.dart';
import 'package:admin_panel/providers/post_feedback_provider.dart';
import 'package:admin_panel/screens/home_screen.dart';
import 'package:admin_panel/screens/login_screen.dart';
import 'package:admin_panel/screens/notifications_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => HomePageProvider()),
      ChangeNotifierProvider(create: (context) => PostFeedbackProvider()),
    ],
    child: const MyApp(),
  ),);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DisasterAid Admin Panel',
      home: LoginScreen(),
    );
  }
}
