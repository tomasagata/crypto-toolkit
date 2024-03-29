import 'dart:typed_data';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class PKEPrivateKey {

  // ------------ CONSTRUCTORS ------------
  factory PKEPrivateKey(PolynomialMatrix s){
    return PKEPrivateKey._internal(s);
  }

  factory PKEPrivateKey.deserialize(Uint8List byteArray, int n, int k, int q) {
    var s = PolynomialMatrix.deserialize(byteArray, k, 1, 12, n, q);
    return PKEPrivateKey._internal(s);
  }

  PKEPrivateKey._internal(this.s);



  // ------------ INSTANCE VARIABLES ------------
  PolynomialMatrix s;



  // ------------ PUBLIC API ------------

  Uint8List serialize() {
    return s.serialize(12);
  }

}