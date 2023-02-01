import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_shop_vendor_app/Provider/product_vendor.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendor =
      FirebaseFirestore.instance.collection('vendors');
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference maincategories =
      FirebaseFirestore.instance.collection('maincategories');
  final CollectionReference subcategories =
      FirebaseFirestore.instance.collection('subcategories');
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(_file);

    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<List> uploadFiles(
      {List<XFile>? images, String? ref, ProductProvider? provider}) async {
    var imageUrls = await Future.wait(
      images!.map(
          (_image) => uploadFile(image: File(_image.path), reference: ref)),
    );

    provider!.getFormData(imageUrl: imageUrls);
    return imageUrls;
  }

  Future uploadFile({File? image, String? reference}) async {
    firebase_storage.Reference storageReference =
        storage.ref().child('$reference/${DateTime.now().microsecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);

    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return vendor
        .doc(user!.uid)
        .set(data)
        // ignore: avoid_print
        .then((value) => print("User Added"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> saveToDb({Map<String, dynamic>? data, BuildContext? context}) {
    // Call the user's CollectionReference to add a new user
    return products
        .add(data)
        // ignore: avoid_print
        .then((value) => scaffold(context, 'Product Saved')
            // ignore: avoid_print
           );
  }

  String formatedDate(date) {
    var outPutFormate = DateFormat('dd/MM/yyyy');
    var outputDate = outPutFormate.format(date);
    return outputDate;
  }

  String formattedNumber(number){
  var f = NumberFormat('#,#,###');
  String formattedNumber = f.format(number);
  return formattedNumber;
  }

  Widget formField(
      {String? label,
      TextInputType? inputType,
      void Function(String)? onChanged,
      int? minLines,
      int? maxLines}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
        return null;
      },
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  scaffold(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }
}
