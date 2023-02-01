import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';
import 'package:multi_shop_vendor_app/Widget/add_product/attributes_tab.dart';
import 'package:multi_shop_vendor_app/Widget/add_product/general_tab.dart';
import 'package:multi_shop_vendor_app/Widget/add_product/images_tab.dart';
import 'package:multi_shop_vendor_app/Widget/add_product/shipping_tab.dart';
import 'package:provider/provider.dart';

import '../Provider/product_vendor.dart';
import '../Provider/vendor_provider.dart';
import '../Widget/add_product/inventory_tab.dart';
import '../Widget/custom_drawer.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = 'add-product-screen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _vendor = Provider.of<VendorProvider>(context);
    FirebaseServices _services = FirebaseServices();

    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(' Add new Product '),
            elevation: 0,
            bottom: const TabBar(
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4, color: Colors.white),
                ),
                tabs: [
                  Tab(
                    child: Text('General'),
                  ),
                  Tab(
                    child: Text('Inventory'),
                  ),
                  Tab(
                    child: Text('Shipping'),
                  ),
                  Tab(
                    child: Text('Attributes'),
                  ),
                  Tab(
                    child: Text('Linked Products'),
                  ),
                  Tab(
                    child: Text('Images'),
                  ),
                ]),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              GeneralTab(),
              InventoryTab(),
              ShippingTab(),
              AttributesTab(),
              Center(child: Text("Link Products Tab")),
              ImagesTab(),
            ],
          ),
          persistentFooterButtons: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_provider.imageFiles!.isEmpty) {
                    _services.scaffold(context, 'Image not Selected');
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Please wait.....');
                    _provider.getFormData(seller: {
                      'name': _vendor.vendor!.businessName,
                      'uid': _services.user!.uid
                    });
                    _services
                        .uploadFiles(
                      images: _provider.imageFiles,
                      ref:
                          'products/${_vendor.vendor!.businessName}/${_provider.productData!['productName']}',
                      provider: _provider,
                    )
                        .then((value) {
                      if (value.isNotEmpty) {
                        _services
                            .saveToDb(
                          data: _provider.productData,
                          context: context,
                        )
                            .then((value) {
                          EasyLoading.dismiss();
                          setState(() {
                            _provider.clearProductData();
                          });
                        });
                      }
                    });
                  }
                },
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
