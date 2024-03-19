import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/kyber.dart';
import 'package:crypto_toolkit/algorithms/kyber/polynomials/polynomial_ring.dart';
import 'package:crypto_toolkit/algorithms/kyber/polynomials/polynomial_ring_matrix.dart';
import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:flutter/material.dart';


void main() {
  // runApp(const App());
  var kyberInstance = Kyber.kem512().innerPKE;
  var seed = BytesBuilder();
  seed.add(
      [ 0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7]
  );

  var message = BytesBuilder();
  message.add(ascii.encode("HOLA A TODOS! COMO LES VA?     ."));
  print(message.length);

  var (pk, sk) = kyberInstance.generateKeys(seed.toBytes());
  var cypher = kyberInstance.encrypt(pk, message.toBytes(), seed.toBytes());
  var decryptedMessage = kyberInstance.decrypt(sk, cypher);
  print(ascii.decode(decryptedMessage));
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