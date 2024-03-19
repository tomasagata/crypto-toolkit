import 'dart:typed_data';

class PolynomialRing {
  List<int> coefficients;
  int q;
  int n;


  // --------- CONSTRUCTORS ---------
  /// Creates a new polynomial from a coefficient list.
  ///
  /// The coefficient list does not need to be normalized.
  factory PolynomialRing.from(List<int> coefficientList, int n, int q) {
    var normalizedCoefficients = _normalize(coefficientList, n);
    normalizedCoefficients = _moduloCoefs(normalizedCoefficients, q);

    return PolynomialRing._internal(normalizedCoefficients, n, q);
  }

  factory PolynomialRing.zeros(int n, int q) {
    return PolynomialRing._internal(List.filled(n, 0), n, q);
  }

  factory PolynomialRing.deserialize(
      Uint8List byteArray, int wordSize, int n, int q) {
    var coefficients = _decode(byteArray, wordSize);

    if(coefficients.length != n) {
      throw ArgumentError("Polynomial size n=$n was given but "
          "${coefficients.length} coefficients were found");
    }

    return PolynomialRing.from(coefficients, n, q);
  }

  PolynomialRing._internal(this.coefficients, this.n, this.q);




  // --------- INTERNAL METHODS ---------

  /// Creates a new normalized list of coefficients
  static List<int> _normalize(List<int> coefficientList, int n) {
    if (coefficientList.length > n){
      throw ArgumentError("Coefficient list length cannot be greater than n");
    }

    List<int> coefficients = List.filled(n, 0);
    for (int i = 0; i < n && i < coefficientList.length; i++) {
      coefficients[i] = coefficientList[i];
    }
    return coefficients;
  }

  static List<int> _moduloCoefs(List<int> coefficients, int q) {
    var results = <int>[];
    for (var coef in coefficients) {
      results.add(coef.remainder(q));
    }
    return results;
  }

  /// Takes in a list of words of size [wordSize] and returns
  /// a list of their bit representations.
  static List<int> _wordsToBits(List<int> words, int wordSize) {
    List<int> bits = [];

    // Iterate through each word in the list
    for (int word in words) {
      // Convert the word to its binary representation
      String binaryString = word.toRadixString(2);

      // Pad the binary representation with leading zeros if necessary
      while (binaryString.length < wordSize) {
        binaryString = '0$binaryString';
      }

      // Add the bits of the binary representation to the bits list
      for (int i = 0; i < binaryString.length; i++) {
        bits.add(int.parse(binaryString[i]));
      }
    }

    return bits;
  }

  /// Takes in a list of bit representations and returns
  /// a list of words of size [wordSize].
  static List<int> _bitsToWords(List<int> bits, int wordSize) {
    List<int> words = [];

    // Calculate the number of bits needed to represent a word of size wordSize
    int bitsPerWord = wordSize * bits.length;

    // Ensure that the number of bits is divisible evenly by the wordSize
    if (bitsPerWord % wordSize != 0) {
      throw ArgumentError('Number of bits is not divisible evenly by wordSize');
    }

    // Iterate through the bits list, extracting words of size wordSize
    for (int i = 0; i < bits.length; i += wordSize) {
      int word = 0;

      // Extract wordSize number of bits from the bits list
      for (int j = 0; j < wordSize; j++) {
        word = (word << 1) | bits[i + j];
      }

      // Add the extracted word to the list of words
      words.add(word);
    }

    return words;
  }

  /// Receives a list of <code>l*[w]/8</code> coefficients with values
  /// in {0, 1, ..., 255} and returns a list of <code>l</code>
  /// coefficients with values in {0, 1, ..., 2^[w] - 1}
  static List<int> _decode(Uint8List encodedCoefficients, int w) {
    return _bitsToWords(_wordsToBits(encodedCoefficients, w), 8);
  }






  // --------- INTERNAL METHODS ---------

  /// Compress [x] mod [q] down into [d] bits.
  ///
  /// Result is a number y, where 0 <= y < 2^d
  int _compress(int x, int d, int q) {
    var compressionLimit = 1<<d; // 2^d
    return ( (compressionLimit / q) * x ).round().remainder(compressionLimit);
  }

  /// Decompress [y] back to an [x]' mod [q]
  ///
  /// x' follows that abs(x' - x) <= Round( (q/2)^(d+1) )
  int _decompress(int y, int d, int q) {
    var compressionLimit = 1<<d; //2^d
    return ( (q / compressionLimit) * y ).round();
  }

  /// Receives a list of <code>l</code> coefficients with values
  /// in {0, 1, ..., 2^w - 1} and returns a list of <code>l*w/8</code>
  /// coefficients with values in {0, 1, ..., 255}
  Uint8List _encode(List<int> coefficients, int w) {
    return Uint8List.fromList(_bitsToWords(_wordsToBits(coefficients, 8), w));
  }

  /// Divides [coefficients] by X^n + 1 and returns the remainder as a list of
  /// coefficients.
  ///
  /// For an explanation regarding the algorithm check out
  /// https://www.geeksforgeeks.org/division-algorithm-for-polynomials/
  List<int> _modulo(List<int> coefficients) {
    if(coefficients.length <= n) {
      return coefficients;
    }

    // g(X) = 1 * X^n + 1 * X^0 = X^n + 1
    List<int> denominator = List.filled(n+1, 0);
    denominator[n] = 1;
    denominator[0] = 1;


    List<int> numerator = List.from(coefficients);

    while (numerator.length >= denominator.length) {
      double factor = numerator.last / denominator.last;
      for (int i = 0; i < denominator.length; i++) {
        numerator[numerator.length - i - 1] = (numerator[numerator.length - i - 1] - factor * denominator[denominator.length - i - 1]).round();
      }
      numerator.removeLast();
    }

    return numerator;
  }







  // --------- PUBLIC METHODS ---------

  /// Adds this polynomial to g and returns a new polynomial
  ///
  /// For an in-depth explanation on the algorithm, please check out
  /// https://www.geeksforgeeks.org/program-add-two-polynomials/
  PolynomialRing add(PolynomialRing g) {
    if (g.q != q) throw ArgumentError("g cannot have a different modulus q");
    if (g.n != n) throw ArgumentError("g cannot have a different n");

    List<int> resultingCoefficients = List.filled(n, 0);
    for (int i=0; i<n; i++){
      resultingCoefficients[i] = (coefficients[i] + g.coefficients[i]) % q;
    }

    return PolynomialRing.from(resultingCoefficients, n, q);
  }

  /// Multiplies this polynomial by a and returns the result as a new polynomial.
  PolynomialRing multiplyInt(int a) {
    List<int> resultingCoefficients = List.filled(coefficients.length, 0);

    for (int i=0; i < coefficients.length; i++) {
      resultingCoefficients[i] += coefficients[i] * a;
      resultingCoefficients[i] %= q;
    }

    return PolynomialRing.from(resultingCoefficients, n, q);
  }

  /// Multiplies this polynomial by g and returns the result as a new polynomial.
  ///
  /// For an in-depth explanation on the algorithm, please check out
  /// https://www.geeksforgeeks.org/multiply-two-polynomials-2/
  PolynomialRing multiply(PolynomialRing g) {
    if (g.q != q) throw ArgumentError("g cannot have a different modulus q");
    if (g.n != n) throw ArgumentError("g cannot have a different n");

    int resultingDegree = 2*(n-1);
    List<int> resultingCoefficients = List.filled(resultingDegree + 1, 0);

    for (int i=0; i < coefficients.length; i++) {
      for (int j=0; j < g.coefficients.length; i++) {
        resultingCoefficients[i + j] += coefficients[i] * g.coefficients[j];
        resultingCoefficients[i + j] %= q;
      }
    }

    return PolynomialRing.from(_modulo(resultingCoefficients), n, q);
  }

  /// Compresses this polynomial from modulo [q] down to [d] bits.
  ///
  /// Achieves compression by individually compressing its coefficients
  PolynomialRing compress(int d) {
    List<int> compressedCoefficients = [];
    for (var coef in coefficients) {
      compressedCoefficients.add(_compress(coef, d, q));
    }
    return PolynomialRing.from(compressedCoefficients, n, q);
  }

  /// Decompresses this polynomial from [d] bits to modulo [q].
  ///
  /// Achieves decompression by individually decompressing its coefficients
  PolynomialRing decompress(int d) {
    List<int> decompressedCoefficients = [];
    for (var coef in coefficients) {
      decompressedCoefficients.add(_decompress(coef, d, q));
    }
    return PolynomialRing.from(decompressedCoefficients, n, q);
  }

  PolynomialRing minus(PolynomialRing g) {
    if (g.q != q) throw ArgumentError("g cannot have a different modulus q");
    if (g.n != n) throw ArgumentError("g cannot have a different n");

    List<int> resultingCoefficients = List.filled(n, 0);
    for (int i=0; i < n; i++) {
      resultingCoefficients[i] = (coefficients[i] - g.coefficients[i]) % q;
    }

    return PolynomialRing.from(resultingCoefficients, n, q);
  }

  Uint8List serialize(int w) {
    return _encode(coefficients, w);
  }

}