import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {


  MyHomePage({Key? key,}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        title: const Text('Stripe Payment', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 400,),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: (){
              makePayment("25");
              },
            child: const Text('Payment'),
          ),
        ],
      )
    );
  }

  Future<void> makePayment(String loanAmount) async {
    try {
      paymentIntentData =
      await createPaymentIntent('25', 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Sabahat',
        ),
      );
      displayPaymentSheet();
    } catch (e) {
      print('exception' + e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        // orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paid successfully")),
        );

        paymentIntentData = null;
      }).onError((error, stackTrace) {});
    } on StripeException catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled"),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
          'Bearer sk_test_51NWBX3KC8S9glFdiRJTz7txhZosjNhUO9Ag8nTJasYoqKBpMRU8yIm3Y110OzMBe2bgELYj9P07RtEVc9OUxWOl200UVt88SRX',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('exception' + e.toString());
      throw e;
    }
  }

  String calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
