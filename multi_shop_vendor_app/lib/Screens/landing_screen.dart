import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Screens/home_screen.dart';
import 'package:multi_shop_vendor_app/Screens/login_scren.dart';
import 'package:multi_shop_vendor_app/Screens/registration_screen.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';

import '../Model/vendor_model.dart';

class LandingScreen extends StatelessWidget {
  static const String id = 'landing-screen';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _services.vendor.doc(_services.user!.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.data!.exists) {
              return const RegistrationScreen();
            }
            Vendor vendor =
                Vendor.fromJson(snapshot.data!.data() as Map<String, dynamic>);

                if(vendor.approved==true){
                    return  const HomeScreen();
                }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: vendor.logo!,
                          placeholder: (context, url) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      vendor.businessName!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your Application send to Multi Shop App \nAdmin will contact You soon!!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                      ),
                      child: const Text('Sign Out'),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
                
          }),
    );
  }
}
