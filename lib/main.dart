import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypto toolkit",
      home: const AppLayout(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlueAccent
      ),
    );
  }

}