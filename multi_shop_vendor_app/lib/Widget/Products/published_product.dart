import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:multi_shop_vendor_app/Widget/Products/product_card.dart';
import '../../Model/product_model.dart';

class PublishedProduct extends StatelessWidget {
  const PublishedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(true),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }
        if (snapshot.docs.isEmpty) {
          return  const Center(child: Text('No Products Published Yet'));
        }
        return ProductCard(
          snapshot: snapshot,
        );
        
      },
    );
  }
}
