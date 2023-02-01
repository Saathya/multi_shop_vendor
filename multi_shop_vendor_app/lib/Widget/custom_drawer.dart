import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Screens/add_product_screen.dart';
import 'package:multi_shop_vendor_app/Screens/home_screen.dart';
import 'package:multi_shop_vendor_app/Screens/login_scren.dart';
import 'package:multi_shop_vendor_app/Screens/product_screen.dart';
import 'package:provider/provider.dart';

import '../Provider/vendor_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    Widget _menu({String? menuTitle, IconData? icon, String? route}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(menuTitle!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
              height: 86,
              color: Colors.grey,
              child: Row(
                children: [
                  DrawerHeader(
                      child: _vendorData.doc == null
                          ? const Text(
                              'Fetching....',
                              style: TextStyle(color: Colors.white),
                            )
                          : Row(
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: _vendorData.doc!['logo']),
                                    const SizedBox(width: 10),
                                    Text(
                                      _vendorData.doc!['businessName'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                ],
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _menu(
                    menuTitle: 'Home',
                    icon: Icons.home_outlined,
                    route: HomeScreen.id),
                ExpansionTile(
                  leading: const Icon(Icons.weekend_outlined),
                  title: const Text("Products"),
                  children: [
                    _menu(
                      menuTitle: 'All Products',
                      route: ProductScreen.id,
                    ),
                    _menu(
                      menuTitle: 'Add Products',
                      route: AddProductScreen.id,
                    ),
                  ],
                ),
                   _menu(
                    menuTitle: 'Sign Out',
                    icon: Icons.exit_to_app,
                    route: LoginScreen.id),
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}
