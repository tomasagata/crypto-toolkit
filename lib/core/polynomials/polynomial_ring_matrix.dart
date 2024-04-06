import 'dart:typed_data';

import 'package:crypto_toolkit/core/ntt/ntt_helper.dart';

import 'polynomial_ring.dart';


/// A polynomial matrix is a container for ```n x m``` polynomials, with
/// n being the number of rows and m the number of columns.
class PolynomialMatrix {
  List<List<PolynomialRing>> elementMatrix;
  int get rows => elementMatrix.length;
  int get columns => elementMatrix[0].length;
  (int rows, int columns) get shape => (rows, columns);
  List<PolynomialRing> get polynomials => elementMatrix.expand((row) => row).toList();


  // --------- CONSTRUCTORS ---------
  /// Creates a new matrix from an existing representation of a matrix
  ///
  /// If given representation is not rectangular, throws [Error]
  factory PolynomialMatrix.fromSquareMatrix(List<List<PolynomialRing>> matrix) {
    int normalVectorSize = matrix[0].length;
    for (int i=1; i<matrix.length; i++) {
      if (matrix[i].length != normalVectorSize) throw Error();
    }
    return PolynomialMatrix._internal(matrix);
  }

  /// Creates a new matrix from a list of elements
  factory PolynomialMatrix.fromList(
      List<PolynomialRing> elements,
      int rows,
      int columns, {
        bool strictSize = false
      }) {
    if( strictSize == true && rows * columns != elements.length ) {
      throw Error();
    }

    List<List<PolynomialRing>> matrix = [];
    for (int i=0; i<rows; i++) {
      var row = <PolynomialRing>[];
      for (int j=0; j<columns; j++) {
        row.add(elements[(columns * i) + j]);
      }
      matrix.add(row);
    }
    return PolynomialMatrix._internal(matrix);
  }

  /// Creates a vector from a list of polynomials
  factory PolynomialMatrix.vector(List<PolynomialRing> elements) {
    // List<List<PolynomialRing>> matrix = [
    //   List.generate(elements.length, (i) => elements[i])
    // ];
    return PolynomialMatrix.fromList(elements, elements.length, 1);
  }

  factory PolynomialMatrix.deserialize(
      Uint8List byteArray,
      int rows,
      int columns,
      int wordSize,
      int n,
      int q, {
        bool isNtt = false,
        Modulus modulusType = Modulus.regular,
        NTTHelper? helper
      }) {
    var coefficients = _decode(byteArray, wordSize);

    if(coefficients.length != rows*columns*n){
      throw ArgumentError(
          "Cannot deserialize matrix of ${rows}x$columns with $coefficients "
              "coefficients"
      );
    }

    var polynomials = <PolynomialRing>[];
    for (int i=0; i<rows; i++) {
      polynomials.add(
          PolynomialRing.from(
            coefficients.sublist(i*n, (i+1)*n),
            n,
            q,
            isNtt: isNtt,
            modulusType: modulusType,
            helper: helper
          )
      );
    }
    return PolynomialMatrix.vector(polynomials);
  }

  PolynomialMatrix._internal(this.elementMatrix);





  // --------- PRIVATE METHODS ---------

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







  // --------- PUBLIC METHODS ---------

  PolynomialMatrix plus(PolynomialMatrix other) {
    if (rows != other.rows || columns != other.columns) {
      throw ArgumentError("Matrices must have the same dimensions for addition.");
    }

    List<List<PolynomialRing>> result = List.generate(rows, (i) {
      return List.generate(columns, (j) {
        return elementMatrix[i][j].plus(other.elementMatrix[i][j]);
      });
    });

    return PolynomialMatrix.fromSquareMatrix(result);
  }

  PolynomialMatrix minus(PolynomialMatrix other) {
    if (rows != other.rows || columns != other.columns) {
      throw ArgumentError("Matrices must have the same dimensions for subtraction.");
    }

    List<List<PolynomialRing>> result = List.generate(rows, (i) {
      return List.generate(columns, (j) {
        return elementMatrix[i][j].minus(other.elementMatrix[i][j]);
      });
    });

    return PolynomialMatrix.fromSquareMatrix(result);
  }

  PolynomialMatrix multiply(PolynomialMatrix other) {
    if (columns != other.rows) {
      throw ArgumentError(
          "Number of columns in the first matrix must be equal to the number of rows in the second matrix for multiplication.");
    }

    List<PolynomialRing> polynomials = [];
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < other.columns; j++) {
        PolynomialRing sum = elementMatrix[i][0].multiply(
            other.elementMatrix[0][j]);
        for (var k = 1; k < columns; k++) {
          var mult = elementMatrix[i][k].multiply(other.elementMatrix[k][j]);
          sum = sum.plus(mult);
        }
        polynomials.add(sum);
      }
    }
    return PolynomialMatrix.fromList(polynomials, rows, other.columns);
  }

  PolynomialMatrix transpose() {
    List<List<PolynomialRing>> result = List.generate(columns, (i) {
      return List.generate(rows, (j) {
        return elementMatrix[j][i];
      });
    });

    return PolynomialMatrix.fromSquareMatrix(result);
  }

  PolynomialMatrix compress(int d) {
    List<PolynomialRing> compressedPolynomials = [];
    for (var row in elementMatrix) {
      for (var poly in row) {
        compressedPolynomials.add(poly.compress(d));
      }
    }
    return PolynomialMatrix.fromList(compressedPolynomials, rows, columns);
  }

  PolynomialMatrix decompress(int d) {
    List<PolynomialRing> decompressedPolynomials = [];
    for (var row in elementMatrix) {
      for (var poly in row) {
        decompressedPolynomials.add(poly.compress(d));
      }
    }
    return PolynomialMatrix.fromList(decompressedPolynomials, rows, columns);
  }

  PolynomialRing toRing() {
    if(rows != 1 || columns != 1) {
      throw StateError("Matrix dimension is greater than 0");
    }

    return elementMatrix[0][0];
  }

  (PolynomialMatrix m1, PolynomialMatrix m0) power2Round(int d) {
    var m1Polynomials = <PolynomialRing>[];
    var m0Polynomials = <PolynomialRing>[];
    for (var column in elementMatrix){
      for (var poly in column){
        var (p1, p0) = poly.power2Round(d);
        m1Polynomials.add(p1);
        m0Polynomials.add(p0);
      }
    }

    return (
      PolynomialMatrix.fromList(m1Polynomials, rows, columns),
      PolynomialMatrix.fromList(m0Polynomials, rows, columns)
    );
  }

  (PolynomialMatrix m1, PolynomialMatrix m0) decompose(int alpha) {
    var m1Polynomials = <PolynomialRing>[];
    var m0Polynomials = <PolynomialRing>[];
    for (var column in elementMatrix){
      for (var poly in column){
        var (p1, p0) = poly.decompose(alpha);
        m1Polynomials.add(p1);
        m0Polynomials.add(p0);
      }
    }

    return (
    PolynomialMatrix.fromList(m1Polynomials, rows, columns),
    PolynomialMatrix.fromList(m0Polynomials, rows, columns)
    );
  }


  Uint8List serialize(int d) {
    var result = BytesBuilder();
    for (var vector in elementMatrix){
      for (var poly in vector) {
        result.add(poly.serialize(d));
      }
    }
    return result.toBytes();
  }

  @override
  String toString() {
    var matrix = "[\n";
    for (var row in elementMatrix) {
      matrix += "\t[\n";
      for (var poly in row) {
        matrix += "\t\t${poly.toString()}\n";
      }
      matrix += "\t],\n";
    }
    matrix += "]\n";
    return matrix;
  }

  PolynomialMatrix scale(PolynomialRing p) {
    List<PolynomialRing> scaledPolynomials = [];
    for (var row in elementMatrix) {
      for (var poly in row) {
        scaledPolynomials.add(poly.multiply(p));
      }
    }
    return PolynomialMatrix.fromList(scaledPolynomials, rows, columns);
  }

  bool checkNormBound(int bound) {
    for (var row in elementMatrix) {
      for (var poly in row) {
        if (poly.checkNormBound(bound)) return true;
      }
    }
    return false;
  }

  PolynomialMatrix scaleInt(int a) {
    List<PolynomialRing> resultingPolynomials = [];
    for (var row in elementMatrix) {
      for (var poly in row) {
        resultingPolynomials.add(poly.multiplyInt(a));
      }
    }
    return PolynomialMatrix.fromList(resultingPolynomials, rows, columns);
  }

  PolynomialMatrix toNtt() {
    for (var row in elementMatrix) {
      for (var poly in row) {
        poly.toNtt();
      }
    }
    return this;
  }

  PolynomialMatrix fromNtt() {
    for (var row in elementMatrix) {
      for (var poly in row) {
        poly.fromNtt();
      }
    }
    return this;
  }

  PolynomialMatrix copy() {
    List<PolynomialRing> copiedPolynomials = [];
    for (var row in elementMatrix) {
      for (var poly in row) {
        copiedPolynomials.add(poly.copy());
      }
    }

    return PolynomialMatrix.fromList(copiedPolynomials, rows, columns);
  }

}