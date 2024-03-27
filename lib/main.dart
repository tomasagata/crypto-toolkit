import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/kyber.dart';
import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:flutter/material.dart';


void main() {
  // runApp(const App());
  var kyberInstance = Kyber.kem512().innerPKE;
  var keyGenerationSeed = BytesBuilder();
  keyGenerationSeed.add(
      [ 0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7,
        0, 1, 2, 3, 4, 5, 6, 7]
  );

  var encryptionSeed = BytesBuilder();
  encryptionSeed.add(
    [
      7, 6, 5, 4, 3, 2, 1, 0,
      7, 6, 5, 4, 3, 2, 1, 0,
      7, 6, 5, 4, 3, 2, 1, 0,
      7, 6, 5, 4, 3, 2, 1, 0
    ]
  );

  var message = BytesBuilder();
  message.add([0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1]);
  print(message.length);

  var (pk, sk) = kyberInstance.generateKeys(keyGenerationSeed.toBytes());
  var cypher = kyberInstance.encrypt(pk, message.toBytes(), encryptionSeed.toBytes());
  print(cypher.serialize());
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