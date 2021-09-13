import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezeptverwaltung/domains/user.dart';
import 'package:rezeptverwaltung/providers/receipt_provider.dart';
import 'package:rezeptverwaltung/providers/user_provider.dart';
import 'package:rezeptverwaltung/util/user_preferences.dart';

class Receipt extends StatefulWidget {
  final int receiptId;
  const Receipt(this.receiptId);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  List<dynamic> _steps;

  void getSteps() {
    final Future<Map<String, dynamic>> successfulMessage =
    context.read<ReceiptProvider>().getSteps(widget.receiptId);

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

  @override
  void initState() {
    super.initState();
    this.getSteps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Rezept"),
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