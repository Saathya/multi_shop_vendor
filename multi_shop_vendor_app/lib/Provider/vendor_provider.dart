import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';

import '../Model/vendor_model.dart';

class VendorProvider with ChangeNotifier {
  DocumentSnapshot? doc;
  Vendor? vendor;
  final FirebaseServices _services = FirebaseServices();
  getVendorData() {
    _services.vendor.doc(_services.user!.uid).get().then((document) {
      doc = document;
      vendor = Vendor.fromJson(document.data() as Map<String, dynamic>);
      notifyListeners();
    });
  }
}
