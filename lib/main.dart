import 'package:flutter/material.dart';
import 'package:moodle_app/screens/addwebinars_screen.dart';
import 'package:moodle_app/screens/webinars_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/store_screen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open the Hive boxes
  await Hive.openBox('login');
  await Hive.openBox('accounts');

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moodle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/Store':(context) => StoreScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/roundTablesWebinars': (context) => const RoundTablesWebinarsScreen(),
        '/addWebinar': (context) => const AddWebinarScreen(), // Add the new route
      },
    );
  }
}
