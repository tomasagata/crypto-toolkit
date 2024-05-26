import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_toolkit/core/ntt/ntt_helper.dart';
import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class DilithiumPublicKey {
  Uint8List rho;
  PolynomialMatrix t1;


  DilithiumPublicKey(this.rho, this.t1);

  factory DilithiumPublicKey.deserialize(Uint8List bytes, int dilithiumVersion) {
    int k;

    if(dilithiumVersion == 2) {
      k = 4;
    } else if (dilithiumVersion == 3) {
      k = 6;
    } else if (dilithiumVersion == 5) {
      k = 8;
    } else {
      throw ArgumentError("Invalid dilithium version selected");
    }

    if(bytes.length != 32 + (k*10*32)) {
      throw ArgumentError("Dilithium public key size mismatch");
    }

    var rho = bytes.sublist(0, 32);
    var t1 = _deserializeT1(bytes.sublist(32), k);

    return DilithiumPublicKey(rho, t1);
  }

  static PolynomialMatrix _deserializeT1(Uint8List bytes, int k) {
    return PolynomialMatrix.deserialize(bytes, k, 1, 10, 256, 8380417, helper: NTTHelper.dilithium());
  }

  Uint8List _serializeT1() {
    return t1.serialize(10);
  }


  String get base64 => base64Encode(serialize());

  Uint8List serialize() {
    var result = BytesBuilder();
    result.add(rho);
    result.add( _serializeT1() );
    return result.toBytes();
  }
}