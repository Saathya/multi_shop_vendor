import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Provider/product_vendor.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();
  bool? __manageInventory = false;
  @override

  Widget build(BuildContext context) {
     super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _services.formField(
                label: 'SKU',
                inputType: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(
                    sku: value,
                  );
                }),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Manage Inventory ?',
                  style: TextStyle(color: Colors.grey),
                ),
                value: __manageInventory,
                onChanged: (value) {
                  setState(() {
                    __manageInventory = value;
                  provider.getFormData(manageInventory:value,
                  );
                  });
                }),
                if(__manageInventory==true)
             Column(
               children: [
                    _services.formField(
                  label: 'Stock on hand',
                  inputType: TextInputType.number,
                  onChanged: (value){
                    provider.getFormData(

                      soh:int.parse(value),
                    );

                  }

                ), _services.formField(
                  label: 'Re-order-level',
                  inputType: TextInputType.number,
                  onChanged: (value){
                    provider.getFormData(

                      reOrderLevel:int.parse(value),
                    );

                  }

                )
               ],
             )
          ],
        ),
      );
    });
  }
}
