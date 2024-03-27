import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

/// Wrapper for a Pseudo-Random Function that takes in a message
/// and generates an infinite output SHAKE256 hash.
class PRF {
  factory PRF(Uint8List message) {
    var hashSink = const Shake256(0).createSink();
    hashSink.add(message);
    return PRF._internal(hashSink);
  }

  PRF._internal(this._hashSink);

  final BlockHashSink _hashSink;

  int _offset = 0;

  /// Reads [bytes] from the (infinitely long) digest.
  Uint8List read(int bytes) {
    var digestBytes = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      if (_offset == _hashSink.blockLength) {
        _hashSink.$update(_hashSink.buffer);
        _offset = 0;
      }
      digestBytes[i] = _hashSink.buffer[_offset];
      _offset++;
    }
    return digestBytes;
  }

}