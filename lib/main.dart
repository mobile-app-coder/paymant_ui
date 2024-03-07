import 'package:flutter/material.dart';
import 'package:paymant_ui/pages/home_page.dart';
import 'package:paymant_ui/services/root_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RootService.init();
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
