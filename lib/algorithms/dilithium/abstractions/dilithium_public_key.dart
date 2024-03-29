import 'dart:typed_data';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class DilithiumPublicKey {
  DilithiumPublicKey(this.rho, this.t1);

  factory DilithiumPublicKey.deserialize() {
    throw UnimplementedError();
  }

  Uint8List rho;
  PolynomialMatrix t1;

  Uint8List serialize() {
    var result = BytesBuilder();
    result.add(rho);
    result.add(t1.serialize(10));
    return result.toBytes();
  }
}