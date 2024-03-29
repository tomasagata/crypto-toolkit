import 'package:crypto_toolkit/core/ntt/ntt_helper.dart';
import 'package:crypto_toolkit/core/polynomials/polynomial_ring.dart';
import 'package:crypto_toolkit/core/polynomials/polynomial_ring_matrix.dart';

class PolynomialFactory {
  int n;
  int q;
  NTTHelper helper;


  PolynomialFactory({
    required this.n,
    required this.q,
    required this.helper
  });

  factory PolynomialFactory.kyber() {
    return PolynomialFactory(
        n: 256,
        q: 3329,
        helper: NTTHelper.kyber()
    );
  }

  factory PolynomialFactory.dilithium() {
    return PolynomialFactory(
      n: 256,
      q: 8380417,
      helper: NTTHelper.dilithium()
    );
  }



  PolynomialRing ring(List<int> coefficients) {
    return PolynomialRing.from(coefficients, n, q);
  }

  PolynomialMatrix vector(List<PolynomialRing> polynomials) {
    return PolynomialMatrix.vector(polynomials);
  }

  PolynomialMatrix matrix(List<PolynomialRing> polynomials, int rows, int columns) {
    return PolynomialMatrix.fromList(polynomials, rows, columns);
  }
}