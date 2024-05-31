import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_public_key.dart';

class KemPublicKey {
  final PKEPublicKey publicKey;
  String get base64 => base64Encode(serialize());

  const KemPublicKey({
    required this.publicKey
  });

  factory KemPublicKey.deserialize(Uint8List bytes, int kyberVersion) {
    return KemPublicKey(
        publicKey: PKEPublicKey.deserialize(bytes, kyberVersion)
    );
  }


  Uint8List serialize() {
    return publicKey.serialize();
  }
}