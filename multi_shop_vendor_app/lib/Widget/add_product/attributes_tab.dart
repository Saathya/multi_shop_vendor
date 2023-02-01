import 'package:flutter/material.dart';
import 'package:multi_shop_vendor_app/Provider/product_vendor.dart';
import 'package:provider/provider.dart';

import '../../Services/firebase_service.dart';

class AttributesTab extends StatefulWidget {
  const AttributesTab({Key? key}) : super(key: key);

  @override
  State<AttributesTab> createState() => _AttributesTabState();
}

class _AttributesTabState extends State<AttributesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();

  final List<String> _sizeList = [];
  final _sizeText = TextEditingController();
  bool? saved = false;
  bool? _entered = false;
  String? selectedUnit;

  final List<String> _units = [
    'Kg',
    'Gram',
    'Litre',
    'ml',
    'Nos.',
    'Feet',
    'Yard',
    'Set',
  ];

  Widget _unitDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Select unit',
        style: TextStyle(fontSize: 18),
      ),
      value: selectedUnit,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          selectedUnit = newValue!;
          provider.getFormData(
            unit: newValue,
          );
        });
      },
      items: _units.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      validator: (value) {
       if(value!.isEmpty){
        return 'Select unit';
       }
       return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _services.formField(
                label: 'Brand',
                inputType: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(
                    brand: value,
                  );
                }),

                _unitDropDown(provider),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _sizeText,
                  decoration: const InputDecoration(
                    label: Text('size'),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _entered = true;
                      });
                    }
                  },
                )),
                if (_entered!)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sizeList.add(_sizeText.text.toUpperCase());
                        _sizeText.clear();
                        _entered = false;
                        saved = false;
                      });
                    },
                    child: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (_sizeList.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _sizeList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
                            setState(() {
                              _sizeList.removeAt(index);
                              provider.getFormData(sizeList: _sizeList);
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.purple,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _sizeList[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            if (_sizeList.isNotEmpty)
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('* long press to delete',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              provider.getFormData(sizeList: _sizeList);
                              saved = true;
                            });
                          },
                          child:
                              Text(saved == true ? 'Saved' : 'Press to save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            _services.formField(
                label: 'Add other Details',
                maxLines: 2,
                onChanged: (value) {
                  provider.getFormData(
                    otherDetails: value,
                  );
                })
          ],
        ),
      );
    });
  }
}
