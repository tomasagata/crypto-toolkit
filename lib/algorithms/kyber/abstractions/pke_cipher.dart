import 'dart:typed_data';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring.dart';
import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class PKECypher {

  // -------------- CONSTRUCTORS --------------
  PKECypher({
    required this.u,
    required this.v,
    required this.du,
    required this.dv
  });

  factory PKECypher.deserialize(
      Uint8List byteArray, int n, int k, int q, int du, int dv) {
    var sizeU = (du * k * n / 8).round();
    var serializedU = byteArray.sublist(0, sizeU);
    var serializedV = byteArray.sublist(sizeU);

    var u = PolynomialMatrix.deserialize(serializedU, k, 1, du, n, q).decompress(du);
    var v = PolynomialRing.deserialize(serializedV, dv, n, q).decompress(dv);

    return PKECypher(u: u, v: v, du: du, dv: dv);
  }




  // -------------- PARAMETERS --------------
  PolynomialMatrix u;
  PolynomialRing v;
  int du;
  int dv;





  // -------------- PUBLIC API --------------

  Uint8List serialize() {
    // COMPRESS AND SERIALIZE
    var serializedU = u.compress(du).serialize(du);
    var serializedV = u.compress(dv).serialize(dv);

    // SERIALIZED_CYPHER = SERIALIZED_U || SERIALIZED_V
    var serializedCypher = BytesBuilder();
    serializedCypher.add(serializedU);
    serializedCypher.add(serializedV);

    return serializedCypher.toBytes();
  }

}