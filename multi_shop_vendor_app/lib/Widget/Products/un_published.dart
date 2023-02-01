import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_shop_vendor_app/Model/product_model.dart';
import 'package:multi_shop_vendor_app/Widget/Products/product_card.dart';

class UnPublished extends StatelessWidget {
  const UnPublished({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
           if (snapshot.docs.isEmpty) {
          return  const Center(child: Text('No Un Published Products Yet'));
        }
        return ProductCard(
          snapshot: snapshot,
        );
        // ...
      },
    );
  }
}
