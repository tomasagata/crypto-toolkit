import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../polynomials/polynomial_ring_matrix.dart';

class PKEPublicKey {

  // ------------ CONSTRUCTORS ------------
  factory PKEPublicKey(PolynomialMatrix t, Uint8List rho) {
    return PKEPublicKey._internal(t, rho);
  }

  factory PKEPublicKey.deserialize(Uint8List byteArray, int n, int k, int q) {
    var rho = byteArray.sublist(byteArray.length - 32);
    var serializedT = byteArray.sublist(0, byteArray.length - 32);
    var t = PolynomialMatrix.deserialize(serializedT, k, 1, 12, n, q);
    return PKEPublicKey._internal(t, rho);
  }

  PKEPublicKey._internal(this.t, this.rho);




  // ------------ INSTANCE VARIABLES ------------
  PolynomialMatrix t;
  Uint8List rho;



  // ------------ PUBLIC API ------------

  Uint8List serialize() {
    var result = BytesBuilder();
    result.add(t.serialize(12));
    result.add(rho);
    return result.toBytes();
  }

}