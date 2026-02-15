import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'pages/home.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/dashboard.dart';
import 'pages/profile.dart';
import 'pages/forgot.password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/profile': (context) => const ProfilePage(),
        '/forgot-password': (context) => const ForgotPassword(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("Auth state: ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          print("GOING TO DASHBOARD");
          return const DashboardPage();
        }

        print("GOING TO HOME");
        return const HomePage();
      },
    );
  }
}
