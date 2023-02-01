import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_shop_vendor_app/Provider/product_vendor.dart';
import 'package:multi_shop_vendor_app/Provider/vendor_provider.dart';
import 'package:multi_shop_vendor_app/Screens/add_product_screen.dart';
import 'package:multi_shop_vendor_app/Screens/home_screen.dart';
import 'package:multi_shop_vendor_app/Screens/landing_screen.dart';
import 'package:multi_shop_vendor_app/Screens/login_scren.dart';
import 'package:multi_shop_vendor_app/Screens/product_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType=null;
  runApp(
    MultiProvider(
      providers: [
        Provider<VendorProvider>(create: (_) => VendorProvider()),
         Provider<ProductProvider>(create: (_) => ProductProvider()),
      ],
      child:  const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        builder: EasyLoading.init(),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          LandingScreen.id: (context) => const LandingScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          ProductScreen.id: (context) => const ProductScreen(),
          AddProductScreen.id: (context) => const AddProductScreen(),
        });
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, LoginScreen.id),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return const Scaffold(
      body: Center(
          child: Text(
        "Multi Vendor App",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
      )),
    );
  }
}
