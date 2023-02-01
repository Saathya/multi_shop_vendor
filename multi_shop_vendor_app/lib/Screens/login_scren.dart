import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:multi_shop_vendor_app/Screens/landing_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // If the user is already signed-in, use it as initial data

      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Text(
                        'Vendor App',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      )),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Multi Vendor App! Please sign in to continue.'
                        : 'Welcome to Multi Vendor App! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId: "1:306040714963:android:2685a56c57f97f59d44626"),
                PhoneProviderConfiguration(),
              ]);
        }

        // Render your application if authenticated
        return const LandingScreen();
      },
    );
  }
}
