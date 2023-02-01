import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Widget/Products/published_product.dart';
import 'package:multi_shop_vendor_app/Widget/Products/un_published.dart';
import 'package:multi_shop_vendor_app/Widget/custom_drawer.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Product list'),
            elevation: 0,
            bottom: const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 6, color: Colors.white),
              ),
              tabs: [
                Tab(
                  child: Text('Un Published'),
                ),
                Tab(
                  child: Text('Published'),
                )
              ],
            ),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(children: [
            UnPublished(),
            PublishedProduct(),
          ])),
    );
  }
}
