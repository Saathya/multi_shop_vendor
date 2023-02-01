import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Provider/vendor_provider.dart';
import 'package:provider/provider.dart';

import '../Widget/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    final _vendorData = Provider.of<VendorProvider>(context);
    if (_vendorData.doc == null) {
      _vendorData.getVendorData();
    }

    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Dashboard')),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Dashboard Screen",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
