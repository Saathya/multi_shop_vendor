import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';

class Product {
  Product( {this.productId,
    this.productName,
    this.regularPrice,
    this.salesPrice,
    this.taxStatus,
    this.taxValue,
    this.category,
    this.mainCategory,
    this.subCategory,
    this.description,
    this.scheduleDate,
    this.sku,
    this.manageInventory,
    this.soh,
    this.reOrderLevel,
    this.chargeShipping,
    this.shippingCharge,
    this.brand,
    this.sizeList,
    this.otherDetails,
    this.unit,
    this.imageUrl,
    this.seller,
    this.approved,
  });

  Product.fromJson(Map<String, Object?> json)
      : this(
          productName: json['productName']! as String,
          regularPrice: json['regularPrice']! as int,
          salesPrice: json['salesPrice']! as int,
          taxStatus: json['taxStatus']! as String,
          taxValue: json['taxValue']== null ? null:json['taxValue']! as double,
          category: json['category']! as String,
          mainCategory: json['mainCategory']== null ? null:json['mainCategory']! as String,
          subCategory: json['subCategory'] == null ? null: json['subCategory']! as String,
          description: json['description']==null? null:json['description'] ! as String,
          scheduleDate: json['scheduleDate']==null? null:json['scheduleDate']! as Timestamp,
          sku: json['sku']==null? null:json['sku']! as String,
          manageInventory: json['manageInventory']==null? null:json['manageInventory']! as bool,
          soh: json['soh']==null? null:json['soh']! as int,
          reOrderLevel: json['reOrderLevel']==null? null:json['reOrderLevel']! as int,
          chargeShipping: json['chargeShipping']==null? null:json['chargeShipping']! as bool,
          shippingCharge: json['shippingCharge']==null? null:json['shippingCharge']! as int,
          brand: json['brand']==null? null:json['brand']! as String,
          sizeList: json['sizeList']==null? null:json['sizeList']! as List,
          otherDetails: json['otherDetails']==null? null:json['otherDetails']! as String,
          unit: json['unit']==null? null:json['unit']! as String,
          imageUrl: json['imageUrl']! as List,
          seller: json['seller']! as Map,
          approved: json['approved']! as bool,
        );
  final String? productName;
  final int? regularPrice;
  final int? salesPrice;
  final String? taxStatus;
  final double? taxValue;
  final String? category;
  final String? mainCategory;
  final String? subCategory;
  final String? description;
  final Timestamp? scheduleDate;
  final String? sku;
  final bool? manageInventory;
  final int? soh;
  final int? reOrderLevel;
  final bool? chargeShipping;
  final int? shippingCharge;
  final String? brand;
  final List? sizeList;
  final String? otherDetails;
  final String? unit;
  final List? imageUrl;
  final Map? seller;
  final bool? approved;
  final String? productId;

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'regularPrice': regularPrice,
      'salesPrice': salesPrice,
      'taxStatus': taxStatus,
      'taxValue': taxValue,
      'category': category,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'description': description,
      'scheduleDate': scheduleDate,
      'sku': sku,
      'manageInventory': manageInventory,
      'soh': soh,
      'reOrderLevel': reOrderLevel,
      'chargeShipping': chargeShipping,
      'shippingCharge': shippingCharge,
      'brand': brand,
      'sizeList': sizeList,
      'otherDetails': otherDetails,
      'unit': unit,
      'imageUrl': imageUrl,
      'seller': seller,
      'approved': approved,
    };
  }
}


FirebaseServices _services = FirebaseServices();
   productQuery(approved) {
  return FirebaseFirestore.instance
      .collection('products').where('approved',isEqualTo: approved).where('seller.uid',isEqualTo:_services.user!.uid )
      .orderBy('productName')
      .withConverter<Product>(
        fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
        toFirestore: (product, _) => product.toJson(),
      );
}
