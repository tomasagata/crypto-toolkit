import 'dart:typed_data';

import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:flutter/material.dart';

import 'algorithms/dilithium/dilithium.dart';


void main() {
  // runApp(const App());
  var dilithium = Dilithium.level2();

  var keygenSeed = Uint8List.fromList([
     0,  1,  2,  3,  4,  5,  6,  7,
     8,  9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26, 27, 28, 29, 30, 31
  ]);

  var (pk, sk) = dilithium.generateKeys(keygenSeed);

  var message = Uint8List.fromList([
    0,  1,  0,  0,  0,  0,  0,  0,
    0,  1,  0,  1,  0,  0,  0,  0,
    0,  1,  0,  1,  0,  1,  0,  0,
    0,  1,  0,  1,  0,  1,  0,  1,
  ]);

  var signature = dilithium.sign(sk, message);

  var valid = dilithium.verify(pk, message, signature);
  print(valid);
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