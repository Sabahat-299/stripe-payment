import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'homepage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51NWBX3KC8S9glFdifWaeata2jExjbUqMKDWlVGVmFFwiydcEzj6latwx0S5NcHo2TCcS7NK2drgZxOKSwHhFmEor00SGZfHQVl';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

