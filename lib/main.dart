import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paymant_ui/models/credit_card_model.dart';
import 'package:paymant_ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var appDocumentary = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentary.path)
    ..registerAdapter(CreditCardAdapter());
  await Hive.openBox("cards_db");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
