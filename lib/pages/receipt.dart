import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/receipt_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class Receipt extends StatefulWidget {
  final dynamic receipt;
  const Receipt(this.receipt);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  List<dynamic> _steps;
  List<dynamic> _ingredients;
  List<dynamic> _unitNames;

  void getSteps() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<ReceiptProvider>().getSteps(widget.receipt['R_ID']);

    successfulMessage.then((response) {
      if (response['status']) {
        setState(() {
          _steps = response['data'];
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  void getIngredients() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<ReceiptProvider>().getIngredients(widget.receipt['R_ID']);

    successfulMessage.then((response) {
      if (response['status']) {
        setState(() {
          _ingredients = response['data'];
        });
        print(_ingredients);
        getUnitNames();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
      }
    });
  }

  void getUnitNames(){
    List<String> unitIds = [];
    if(_ingredients.isNotEmpty){
      _ingredients.forEach((value) {
        unitIds.add(value['E_ID']);
      });

      final Future<Map<String, dynamic>> successfulMessage =
      context.read<ReceiptProvider>().getUnitNames([...{...unitIds}]);

      successfulMessage.then((response) {
        if (response['status']) {
          setState(() {
            _unitNames = response['data'];
          });
          print(_unitNames);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response['message'])));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getSteps();
    this.getIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.receipt['titel']),
          elevation: 0.1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      body: Column(
        children: [
          if (_ingredients != null)
          // Handle your callback
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in _ingredients)
                    InkWell(
                      onTap: () {

                      },
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.fastfood),
                              title: Text(item['name']),
                              subtitle: Text(item['menge'] +
                                  (_unitNames != null ? _unitNames.firstWhere(
                                          (element) => element['E_ID'] == int.parse(item['E_ID']))['einheit'] : '')
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (_steps != null)
          // Handle your callback
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in _steps)
                    InkWell(
                      onTap: () {

                      },
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.fastfood),
                              title: Text(item['schritt_nr']),
                              subtitle: Text(item['anweisung']),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}