import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';
import 'package:provider/provider.dart';

import '../../Provider/product_vendor.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();
  bool? chargeShipping = false;
  @override
  Widget build(BuildContext context) {
        super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Charge Shipping ?',
                  style: TextStyle(color: Colors.grey),
                ),
                value: chargeShipping,
                onChanged: (value) {
                  setState(() {
                    chargeShipping = value;
                    provider.getFormData(
                      chargeShipping: value,
                    );
                  });
                }),

                if(chargeShipping==true)
                 _services.formField(
                label: '\u{20B9} Shipping Charge',
                inputType: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(
                    shippingCharge: int.parse(value),
                  );
                }),

          ],
        ),
      );
    });
  }
}
