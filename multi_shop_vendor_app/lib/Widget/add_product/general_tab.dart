import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Provider/product_vendor.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';
import 'package:provider/provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();

  final List<String> _categories = [];
  String? selectedCategory;
  String? taxStatus;
  String? taxAmount;
  bool? _salesPrice = false;

  Widget _categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Select Category',
        style: TextStyle(fontSize: 18),
      ),
      value: selectedCategory,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
          provider.getFormData(
            category: newValue,
          );
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      validator: (value) {
        if(value!.isEmpty){
          return 'Select Category';
        }
        return null;
      },
    );
  }

  Widget _taxStatusDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Select Tax Status',
        style: TextStyle(fontSize: 18),
      ),
      value: taxStatus,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxStatus = newValue!;
          provider.getFormData(
            taxStatus: newValue,
          );
        });
      },
      items: [
        'Taxable',
        'Non Taxable',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      validator: (value) {
         if(value!.isEmpty){
        return 'Select tax Status';
         }
         return null;
      },
    );
  }

  Widget _taxAmountDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Select Tax Amount',
        style: TextStyle(fontSize: 18),
      ),
      value: taxAmount,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxAmount = newValue!;
          provider.getFormData(
            taxPercentage: taxAmount == 'GST-10%' ? 10 : 12,
          );
        });
      },
      items: [
        'GST-10%',
        'GST-12%',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      validator: (value) {
         if(value!.isEmpty){
        return 'Select tax Percentage';
      }
      return null;
      }
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element['catName']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          _services.formField(
              label: 'Enter Product Name',
              inputType: TextInputType.name,
              onChanged: (value) {
                provider.getFormData(
                  productName: value,
                );
              }),
          _services.formField(
              label: 'Enter Description',
              inputType: TextInputType.multiline,
              minLines: 2,
              maxLines: 10,
              onChanged: (value) {
                provider.getFormData(
                  description: value,
                );
              }),
          const SizedBox(
            height: 10,
          ),
          _categoryDropDown(provider),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.productData!['mainCategory'] ??
                      'Select Main Category',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                if (selectedCategory != null)
                  InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MainCategoryList(
                                selectedCategory: selectedCategory,
                                provider: provider,
                              );
                            }).whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: const Icon(Icons.arrow_drop_down)),
              ],
            ),
          ),
          const Divider(color: Colors.black),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.productData!['subCategory'] ?? 'Select Sub Category',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                if (provider.productData!['mainCategory'] != null)
                  InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SubCategoryList(
                                selectedMainCategory:
                                    provider.productData!['mainCategory'],
                                provider: provider,
                              );
                            }).whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: const Icon(Icons.arrow_drop_down)),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 10,
          ),
          _services.formField(
              label: '\u{20B9} Regular Price',
              inputType: TextInputType.number,
              onChanged: (value) {
                provider.getFormData(
                  regularPrice: int.parse(value),
                );
              }),
          _services.formField(
              label: '\u{20B9} Sell Price',
              inputType: TextInputType.number,
              onChanged: (value) {
                if (int.parse(value) > provider.productData!['regularPrice']) {
                  _services.scaffold(
                      context, 'Sell Price Should be less than Regular Price');
                  return;
                }
                setState(() {
                  provider.getFormData(
                    salesPrice: int.parse(value),
                  );
                  _salesPrice = true;
                });
              }),
          const SizedBox(height: 10),
          if (_salesPrice!)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(5000),
                      ).then((value) {
                        setState(() {
                          provider.getFormData(
                            scheduleDate: value,
                          );
                        });
                      });
                    },
                    child: const Text(
                      'Schedule',
                      style: TextStyle(color: Colors.blue),
                    )),
                if (provider.productData!['scheduleDate'] != null)
                  Text(_services
                      .formatedDate(provider.productData!['scheduleDate'])),
              ],
            ),
          const SizedBox(height: 10),
          _taxStatusDropDown(provider),
          const Divider(
            color: Colors.grey,
          ),
          if (taxStatus == 'Taxable') _taxAmountDropDown(provider),
        ]),
      );
    });
  }
}

class MainCategoryList extends StatelessWidget {
  const MainCategoryList({
    Key? key,
    this.selectedCategory,
    this.provider,
  }) : super(key: key);

  final String? selectedCategory;
  final ProductProvider? provider;

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.maincategories
            .where('category', isEqualTo: selectedCategory)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No main categories'));
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    provider!.getFormData(
                      mainCategory: snapshot.data!.docs[index]['mainCategory'],
                    );
                    Navigator.pop(context);
                  },
                  title: Text(
                    snapshot.data!.docs[index]['mainCategory'],
                  ),
                );
              });
        },
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  const SubCategoryList({
    Key? key,
    this.selectedMainCategory,
    this.provider,
  }) : super(key: key);

  final String? selectedMainCategory;
  final ProductProvider? provider;

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.subcategories
            .where('mainCategory', isEqualTo: selectedMainCategory)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No sub categories'));
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    provider!.getFormData(
                      subCategory: snapshot.data!.docs[index]['subCatName'],
                    );
                    Navigator.pop(context);
                  },
                  title: Text(
                    snapshot.data!.docs[index]['subCatName'],
                  ),
                );
              });
        },
      ),
    );
  }
}
