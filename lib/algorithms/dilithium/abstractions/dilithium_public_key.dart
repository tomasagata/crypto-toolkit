import 'dart:typed_data';

import 'package:crypto_toolkit/data_structures/polynomials/polynomial_ring_matrix.dart';

class DilithiumPublicKey {
  DilithiumPublicKey(this.rho, this.t1);

  factory DilithiumPublicKey.deserialize() {
    throw UnimplementedError();
  }

  Uint8List rho;
  PolynomialMatrix t1;

  Uint8List serialize() {
    throw UnimplementedError();
  }
}