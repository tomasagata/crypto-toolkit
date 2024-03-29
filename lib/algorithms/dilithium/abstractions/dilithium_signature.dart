import 'dart:typed_data';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class DilithiumSignature {
  DilithiumSignature(this.cTilde, this.z, this.h);

  factory DilithiumSignature.deserialize(Uint8List bytes) {
    throw UnimplementedError();
  }

  Uint8List cTilde;
  PolynomialMatrix z;
  PolynomialMatrix h;

  Uint8List serialize() {
    throw UnimplementedError();
  }
}