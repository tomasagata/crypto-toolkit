import 'dart:typed_data';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class DilithiumPrivateKey {
  DilithiumPrivateKey(this.rho, this.K, this.tr, this.s1, this.s2, this.t0);

  factory DilithiumPrivateKey.deserialize() {
    throw UnimplementedError();
  }

  Uint8List rho;
  Uint8List K;
  Uint8List tr;
  PolynomialMatrix s1;
  PolynomialMatrix s2;
  PolynomialMatrix t0;

  Uint8List serialize() {
    throw UnimplementedError();
  }

}