import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hashlib/hashlib.dart';

import '../abstractions/pke_private_key.dart';
import '../abstractions/pke_public_key.dart';
import '../polynomials/polynomial_ring.dart';
import '../polynomials/polynomial_ring_matrix.dart';

class KeyGenerator {

  // ------------ CONSTRUCTORS ------------

  /// Creates a Kyber Key Generator helper.
  ///
  /// [eta1] is the size of "small" coefficients used in the private key.
  /// [eta2] is the size of "small" coefficients used in the noise vectors.
  /// [k] is the size of the public and private keys.
  KeyGenerator(this.n, this.k, this.q, this.eta1, this.eta2);





  // ------------ PARAMETERS ------------
  int n;
  int k;
  int q;
  int eta1;
  int eta2;





  // ------------ KYBER PRIMITIVES ------------

  /// Sample Documentation
  Uint8List _xof(Uint8List seed, int j, int i) {
    Uint8List message = Uint8List.fromList(seed);
    message.add(j);
    message.add(i);
    String messageString = ascii.decode(message);
    return shake128.of(1344).string(messageString, ascii).bytes;
  }


  /// G primitive from Kyber specification.
  ///
  /// G takes in a 256-bit (32-byte) seed and returns
  /// its SHA3-512 hash split in two.
  (Uint8List lower32Bytes, Uint8List upper32Bytes) _g(Uint8List seed) {
    var bytes = sha3_512.string(ascii.decode(seed), ascii).bytes;
    return (bytes.sublist(0, 256), bytes.sublist(256));
  }


  /// Hashes the XOR(seed, nonce) in SHAKE256 and returns
  /// 2000 bytes of digest.
  ///
  /// PRF takes in a 256-bit (32-byte) [seed] and a
  /// [nonce] and returns a 2000-byte SHAKE256 hash.
  Uint8List _prf(Uint8List seed, int nonce) {
    Uint8List message = Uint8List.fromList(seed);
    message.add(nonce);
    String messageString = ascii.decode(message);
    return shake256.of(2000).string(messageString, ascii).bytes;
  }








  // ------------ COEFFICIENT SAMPLING ------------

  /// Samples coefficients from a Centered
  /// Binomial Distribution and returns a Polynomial.
  ///
  /// Takes in a 2*[eta]*[n] bits (2*[eta]*[n]/8 bytes)
  /// array of bytes "[a]" and returns a Polynomial with
  /// [n] coefficients.
  PolynomialRing _cbd(Uint8List a, int eta) {
    assert( a.length == ((2*eta*n/8) as int));

    // Returns a list of 2*n*eta bits
    List<int> bitArray = _getBitArrayFromByteArray(a);
    assert( bitArray.length == 2*n*eta );

    // Group bits in groups of eta and add them as if they were ints
    // Example: eta = 2, bits = [0, 1, 0, 0, 1, 1],
    // groups = [[0, 1], [0, 0], [1, 1]]
    // result = [(0 + 1), (0 + 0), (1 + 1)] = [1, 0, 2]
    // Returns a list of 2*n integers
    List<int> groupResults = _groupAndSumNumbers(bitArray, eta);
    assert( groupResults.length == 2*n );

    List<int> coefficients = [];
    for (var i=0; i<2*n; i=i+2) {
      coefficients.add( (groupResults[i] - groupResults[i+1]) % 3329);
    }
    assert( coefficients.length == n );

    return PolynomialRing.from(coefficients, n, q);
  }

  // Polynomial sampling
  PolynomialRing _sampleUniform(Uint8List stream) {
    List<int> coefficients = [];
    for (var offset = 0; offset < stream.length; offset+=3) {
      var bytes = stream.sublist(offset, offset + 3);
      var numbers = _convertUint8ListToNBitIntegers(bytes, 12);
      for (var num in numbers) {
        if (num >= q) continue;
        coefficients.add(num);
        if (coefficients.length == n) return PolynomialRing.from(coefficients, n, q);
      }
    }
    throw StateError("Exhausted all bytes. Please try again.");
  }

  // TODO: FIND OUT WHAT ".read(64*eta)" DOES
  PolynomialMatrix _sampleNoise(Uint8List sigma, int eta, int offset, int k) {
    List<PolynomialRing> flattenedCoefficients = [];
    for (var i=0; i<k; i++) {
      flattenedCoefficients.add(
          _cbd(
            // Truncate hash result to 2*eta*n/8 = 64*eta bytes when n=256.
              _prf(sigma, i + offset).sublist(0, (2*eta*n/8) as int),
              eta
          )
      );
    }
    return PolynomialMatrix.vector(flattenedCoefficients);
  }

  /// Generates a k*k matrix of samples
  PolynomialMatrix _sampleMatrix(Uint8List rho) {
    List<PolynomialRing> flattenedCoefficients = [];
    for (var i=0; i<k; i++) {
      for (var j=0; j<k; j++) {
        flattenedCoefficients.add(
            _sampleUniform( _xof(rho, j, i) )
        );
      }
    }
    return PolynomialMatrix.fromList(flattenedCoefficients, k, k);
  }





  // ------------ HELPER METHODS ------------

  List<int> _convertUint8ListToNBitIntegers(Uint8List uint8List, int bits) {
    List<int> result = [];
    int value = 0;
    int bitsRemaining = bits;

    for (int byte in uint8List) {
      int bitsInByte = 8;

      while (bitsInByte > 0) {
        if (bitsRemaining >= bitsInByte) {
          value <<= bitsInByte;
          value |= byte;
          bitsRemaining -= bitsInByte;
          bitsInByte = 0;
        } else {
          value <<= bitsRemaining;
          value |= (byte >> (8 - bitsRemaining));
          bitsInByte -= bitsRemaining;
          bitsRemaining = 0;
        }

        if (bitsRemaining == 0) {
          result.add(value);
          value = 0;
          bitsRemaining = bits;
        }
      }
    }

    if (bitsRemaining < bits && bitsRemaining > 0) {
      value <<= (bits - bitsRemaining);
      result.add(value);
    }

    return result;
  }

  /// Takes in a byte array of size x and returns its binary
  /// representation as a bit array of size 8*x
  List<int> _getBitArrayFromByteArray(Uint8List byteArray) {
    List<int> bitArray = [];
    for (var byte in byteArray) {
      List<int> bits = [];
      for (var bit=0; bit<8; bit++) {
        bits.add((byte >> bit) % 2);
      }
      bitArray.addAll(bits);
    }
    return bitArray;
  }

  /// Splits numbers into groups of [groupAmount] and adds the result.
  List<int> _groupAndSumNumbers(List<int> numbers, int groupAmount) {
    if (numbers.length % groupAmount != 0) {
      throw ArgumentError();
    }

    List<int> results = [];
    for (var i=0; i<numbers.length; i+=groupAmount) {
      var sum = 0;
      for (var j=0; j<groupAmount; j++) {
        sum += numbers[i + j];
      }
      results.add(sum);
    }
    return results;
  }





  // ------------ INTERNAL API ------------

  PolynomialMatrix _generateMatrixA(Uint8List rho) {
    return _sampleMatrix(rho);
  }

  PolynomialMatrix _generateVectorS(Uint8List sigma) {
    return _sampleNoise(sigma, eta1, 0, k);
  }

  PolynomialMatrix _generateVectorE(Uint8List sigma) {
    return _sampleNoise(sigma, eta1, k, k);
  }







  // ------------ PUBLIC METHODS ------------

  /// Sample Documentation
  (PKEPublicKey pk, PKEPrivateKey sk) generateKeys(Uint8List seed) {
    var (rho, sigma) = _g(seed);

    var A = _generateMatrixA(rho);
    var s = _generateVectorS(sigma);
    var e = _generateVectorE(sigma);
    var t = A.multiply(s).add(e);

    return (PKEPublicKey(t, rho), PKEPrivateKey(s));
  }

  /// Sample documentation
  (PolynomialMatrix r, PolynomialMatrix e1, PolynomialRing e2)
      generateNoiseVectors(Uint8List seed) {
    // PolynomialRing moduloPolynomial = PolynomialRing.zeros(q);
    // moduloPolynomial.set(coefficient: 1, atDegree: 256);
    // moduloPolynomial.set(coefficient: 1, atDegree: 0);
    
    PolynomialMatrix r = _sampleNoise(seed, eta1, 0, k);//.modulo(moduloPolynomial);
    PolynomialMatrix e1 = _sampleNoise(seed, eta2, k, k);
    PolynomialRing e2 = _sampleNoise(seed, eta2, 2*k, 1).toRing();

    return (r, e1, e2);
  }

  PolynomialMatrix regenerateA(Uint8List rho) {
    if(rho.length != 32) {
      throw ArgumentError("RHO must be 32 bytes in size");
    }
    return _generateMatrixA(rho);
  }

}