import 'dart:typed_data';

import '../abstractions/pke_cipher.dart';
import '../abstractions/pke_private_key.dart';
import '../abstractions/pke_public_key.dart';
import '../generators/key_generator.dart';

import 'package:crypto_toolkit/core/polynomials/polynomial_ring.dart';
import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class KyberPKE {

  // -------------- CONSTRUCTORS --------------

  /// Creates a new custom Kyber PKE implementation
  ///
  /// Any kyber implementation receives the following parameters:
  /// - __[n]__: Maximum degree of the used polynomials
  /// - __[k]__: Number of polynomials per vector
  /// - __[q]__: Modulus for numbers
  /// - __[eta_1], [eta_2]__: Size of "small" coefficients used in the private key and noise vectors.
  /// - __[du], [dv]__: How many bits to retain per coefficient of __u__ and __v__. Kyber will compress
  /// the cypher according to these two variables.
  factory KyberPKE({
    required int n,
    required int k,
    required int q,
    required int eta1,
    required int eta2,
    required int du,
    required int dv,
  }) {
    var keyGenerator = KeyGenerator(n, k, q, eta1, eta2);
    return KyberPKE._internal(n: n, k: k, q: q, du: du, dv: dv, keyGenerator: keyGenerator);
  }

  KyberPKE._internal({
    required this.n,
    required this.k,
    required this.q,
    required this.du,
    required this.dv,
    required this.keyGenerator
  });




  // -------------- PARAMETERS --------------
  int n;
  int k;
  int q;
  int du;
  int dv;
  KeyGenerator keyGenerator;







  // -------------- PUBLIC PKE API --------------

  (PKEPublicKey pk, PKEPrivateKey sk) generateKeys(Uint8List seed) {
    if( seed.length != 32 ) {
      throw ArgumentError("Seed must be 32 bytes in length");
    }
    return keyGenerator.generateKeys(seed);
  }



  PKECypher encrypt(PKEPublicKey pk, Uint8List msg, Uint8List seed) {
    if( msg.length != 32 ) {
      throw ArgumentError("Message must be 32 bytes in length");
    }

    PolynomialMatrix t = pk.t;
    PolynomialMatrix A = keyGenerator.regenerateA(pk.rho);
    var (r, e1, e2) = keyGenerator.generateNoiseVectors(seed);

    var msgPolynomial = PolynomialRing.deserialize(msg, 1, n, q).decompress(1);

    PolynomialMatrix u = A.transpose()
        .multiply(r)
        .plus(e1);

    PolynomialRing v = t.transpose() // 1xn
        .multiply(r) // nx1
        .toRing() // 1x1 -> Unwraps into single PolynomialRing
        .plus(e2)
        .plus(msgPolynomial);

    return PKECypher(u: u, v: v, du: du, dv: dv);
  }


  Uint8List decrypt(PKEPrivateKey sk, PKECypher cypher) {
    var msgPolynomial = cypher.v.minus(sk.s.transpose().multiply(cypher.u).toRing());
    return msgPolynomial.compress(1).serialize(1);
  }


}