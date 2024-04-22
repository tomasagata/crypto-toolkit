import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/dilithium/abstractions/dilithium_private_key.dart';
import 'package:crypto_toolkit/algorithms/dilithium/abstractions/dilithium_public_key.dart';
import 'package:crypto_toolkit/algorithms/dilithium/abstractions/dilithium_signature.dart';
import 'package:crypto_toolkit/screens/app_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'algorithms/dilithium/dilithium.dart';


void main() {
  // runApp(const App());
  var dilithium = Dilithium.level3();

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

  var pkBytes = pk.serialize();
  var skBytes = sk.serialize();
  var sigBytes = signature.serialize();

  var pkPrime = DilithiumPublicKey.deserialize(pkBytes, 3);
  var skPrime = DilithiumPrivateKey.deserialize(skBytes, 3);
  var sigPrime = DilithiumSignature.deserialize(sigBytes, 3);

  var pkPrimeBytes = pkPrime.serialize();
  var skPrimeBytes = skPrime.serialize();
  var sigPrimeBytes = sigPrime.serialize();

  print(listEquals(pkBytes, pkPrimeBytes));
  print(listEquals(skBytes, skPrimeBytes));
  print(listEquals(sigBytes, sigPrimeBytes));
  print("All good!");
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