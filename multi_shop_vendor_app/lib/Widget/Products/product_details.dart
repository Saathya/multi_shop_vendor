import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:multi_shop_vendor_app/Model/product_model.dart';
import 'package:multi_shop_vendor_app/Services/firebase_service.dart';

class ProductDetails extends StatefulWidget {
  final Product? product;
  final String? productId;
  const ProductDetails({
    Key? key,
    this.product,
    this.productId,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool editable = true;
  final _productName = TextEditingController();
  final _brand = TextEditingController();
  final _salesPrice = TextEditingController();
  final _regularPrice = TextEditingController();
  final _description = TextEditingController();
  final _soh = TextEditingController();
  final _reorder = TextEditingController();
  final _shippingCharge = TextEditingController();
  final _otherDetails = TextEditingController();
  final _sizeText = TextEditingController();

  String? taxStatus;
  String? taxAmount;
  DateTime? scheduledDate;
  bool? manageInventory;
  bool? chargeShipping;
  List _sizeList = [];
  bool _addList = false;

  Widget _taxStatusDropDown() {
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
        });
      },
      items: [
        'Taxable',
        'Non Taxable',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Select tax Status';
        }
        return null;
      },
    );
  }

  Widget _taxAmountDropDown() {
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
          });
        },
        items: [
          'GST-10%',
          'GST-12%',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Select tax Percentage';
          }
          return null;
        });
  }

  @override
  void initState() {
    setState(() {
      _productName.text = widget.product!.productName!;
      _brand.text = widget.product!.brand!;
      _salesPrice.text = widget.product!.salesPrice!.toString();
      _regularPrice.text = widget.product!.regularPrice!.toString();
      taxStatus = widget.product!.taxStatus!;
      taxAmount = widget.product!.taxValue == 10 ? 'GST-10%' : 'GST-12%';
      _description.text = widget.product!.description!;
      _soh.text = widget.product!.soh.toString();
      _reorder.text = widget.product!.reOrderLevel.toString();
      _shippingCharge.text = widget.product!.shippingCharge!.toString();
      _otherDetails.text = widget.product!.otherDetails!;
      if (widget.product!.scheduleDate != null) {
        scheduledDate = DateTime.fromMicrosecondsSinceEpoch(
            widget.product!.scheduleDate!.microsecondsSinceEpoch);
      }
      manageInventory = widget.product!.manageInventory;
      chargeShipping = widget.product!.chargeShipping;
      if (widget.product!.sizeList != null) {
        _sizeList = widget.product!.sizeList!;
      }
    });
    super.initState();
  }

  Widget _textField(
      {TextEditingController? controller,
      String? label,
      TextInputType? inputType,
      String? Function(String?)? validator}) {
    return TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return 'enter $label';
              }
              return null;
            });
  }

  updateProduct() {
    EasyLoading.show();
    _services.products.doc(widget.productId).update({
      'brand': _brand.text,
      'productName': _productName.text,
      'description': _description.text,
      'otherDetails': _otherDetails.text,
      'salesPrice': int.parse(_salesPrice.text),
      'regularPrice': int.parse(_regularPrice.text),
      'size': _sizeList,
      'taxStatus': taxStatus,
      'taxValue': taxAmount == 'GST-10%' ? 10.00 : 12.00,
      'manageInventory': manageInventory,
      'soh': int.parse(_soh.text),
      'reOrderLevel': int.parse(_reorder.text),
      'chargeShipping': chargeShipping,
      'shippingCharge': int.parse(_shippingCharge.text),
    }).then((value) {
      setState(() {
        editable = true;
        _addList = false;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.product!.productName!),
          actions: [
            editable
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      setState(() {
                        editable = false;
                      });
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateProduct();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(children: [
            AbsorbPointer(
              absorbing: editable,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.product!.imageUrl!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CachedNetworkImage(imageUrl: e),
                          );
                        }).toList()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Brand:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _textField(
                              label: 'Brand',
                              inputType: TextInputType.text,
                              controller: _brand)),
                    ],
                  ),
                  _textField(
                      label: 'Product Name',
                      inputType: TextInputType.text,
                      controller: _productName),
                  _textField(
                      label: 'Description',
                      inputType: TextInputType.text,
                      controller: _description),
                  _textField(
                      label: 'Other Details',
                      inputType: TextInputType.text,
                      controller: _otherDetails),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Unit :',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(widget.product!.unit!),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (widget.product!.salesPrice != null)
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Sell Price:',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: _textField(
                                              label: 'Sell Price',
                                              inputType: TextInputType.number,
                                              controller: _salesPrice,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ' Enter Sell Price';
                                                }
                                                {
                                                  if (int.parse(value) >
                                                      int.parse(
                                                          _regularPrice.text)) {
                                                    return ' Enter Greater value than Regular Price';
                                                  }
                                                  return null;
                                                }
                                              })),
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      'Regular Price:',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _textField(
                                            label: 'Regular Price',
                                            inputType: TextInputType.number,
                                            controller: _regularPrice,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter regular Price';
                                              }
                                              if (int.parse(value) <
                                                  int.parse(_salesPrice.text)) {
                                                return ' Enter less value than Sell Price';
                                              }
                                              return null;
                                            })),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (scheduledDate != null)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Sell Price untill :'),
                                    Text(_services.formatedDate(scheduledDate)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (editable == false)
                                  ElevatedButton(
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: scheduledDate!,
                                                lastDate: DateTime(5000))
                                            .then((value) {
                                          setState(() {
                                            scheduledDate = value;
                                          });
                                        });
                                      },
                                      child: const Text('Change date'))
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size List : ${_sizeList.isEmpty ? 0 : ""}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (editable == false)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _addList = true;
                                    });
                                  },
                                  child: const Text('Add List'),
                                )
                            ],
                          ),
                          if (_addList)
                            Form(
                              key: _formKey1,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter a value';
                                      }
                                      return null;
                                    },
                                    controller: _sizeText,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  )),
                                  const SizedBox(width: 4),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey1.currentState!.validate()) {
                                        _sizeList
                                            .add(_sizeText.text.toUpperCase());
                                        setState(() {
                                          _sizeText.clear();
                                        });
                                      }
                                    },
                                    child: const Text('Add'),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (_sizeList.isNotEmpty)
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  itemCount: _sizeList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onLongPress: () {
                                          setState(() {
                                            _sizeList.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      Text(_sizeList[index])),
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: _taxStatusDropDown()),
                      const SizedBox(width: 6),
                      if (taxStatus == 'Taxable')
                        Expanded(child: _taxAmountDropDown()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          'Category:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Text(widget.product!.category!),
                      ],
                    ),
                  ),
                  if (widget.product!.mainCategory != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Main Category:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          Text(widget.product!.mainCategory!),
                        ],
                      ),
                    ),
                  if (widget.product!.subCategory != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Sub Category:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          Text(widget.product!.subCategory!),
                        ],
                      ),
                    ),
                  const SizedBox(width: 10),
                  if (widget.product!.manageInventory == true)
                    Container(
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Manage Inventory ?'),
                                value: manageInventory,
                                onChanged: (value) {
                                  setState(() {
                                    manageInventory = value;
                                    if (value == false) {
                                      _soh.clear();
                                      _reorder.clear();
                                    }
                                  });
                                }),
                            if (manageInventory == true)
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text(
                                          'SOH:',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _textField(
                                              label: 'SOH',
                                              inputType: TextInputType.number,
                                              controller: _soh),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Re-Order level:',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _textField(
                                              label: 'Re-Order level',
                                              inputType: TextInputType.number,
                                              controller: _reorder),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Charge Shpping ?'),
                              value: chargeShipping,
                              onChanged: (value) {
                                setState(() {
                                  chargeShipping = value;
                                  if (value == false) {
                                    _shippingCharge.clear();
                                  }
                                });
                              }),
                          if (chargeShipping == true)
                            Row(
                              children: [
                                const Text(
                                  'Shipping Charge:',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _textField(
                                      label: 'Shipping charge',
                                      inputType: TextInputType.number,
                                      controller: _shippingCharge),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        const Text(
                          'SKU :',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(widget.product!.sku!),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
