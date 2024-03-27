import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

import 'abstractions/pke_cipher.dart';
import 'abstractions/pke_private_key.dart';
import 'abstractions/pke_public_key.dart';
import 'kyber_pke/kyber_pke.dart';

class Kyber {

  /// Creates a new generic Kyber implementation
  ///
  /// A generic kyber implementation receives the following parameters:
  /// - __[n]__: Maximum degree of the used polynomials
  /// - __[k]__: Number of polynomials per vector
  /// - __[q]__: Modulus for numbers
  /// - __[eta_1], [eta_2]__: Size of "small" coefficients used in the private key and noise vectors.
  /// - __[du], [dv]__: How many bits to retain per coefficient of __u__ and __v__. Kyber will compress
  /// the cypher according to these two variables.
  Kyber({
    required this.n,
    required this.k,
    required this.q,
    required this.innerPKE
  });

  factory Kyber.custom({
    required int n,
    required int k,
    required int q,
    required int eta_1,
    required int eta_2,
    required int du,
    required int dv
  }) {
    return Kyber(
        n: n, k: k, q: q,
        innerPKE: KyberPKE(
            n: n, k: k, q: q, eta1: eta_1, eta2: eta_2, du: du, dv: dv
        )
    );
  }

  factory Kyber.kem512() {
    return Kyber(
        n: 256, k: 2, q: 3329,
        innerPKE: KyberPKE(
            n: 256, k: 2, q: 3329, eta1: 3, eta2: 2, du: 10, dv: 4
        )
    );
  }

  factory Kyber.kem768() {
    return Kyber(
        n: 256, k: 2, q: 3329,
        innerPKE: KyberPKE(
            n: 256, k: 3, q: 3329, eta1: 2, eta2: 2, du: 10, dv: 4
        )
    );
  }

  factory Kyber.kem1024() {
    return Kyber(
        n: 256, k: 2, q: 3329,
        innerPKE: KyberPKE(
            n: 256, k: 4, q: 3329, eta1: 2, eta2: 2, du: 11, dv: 5
        )
    );
  }



  // -------- MODEL PARAMETERS --------
  int n;
  int k;
  int q;
  KyberPKE innerPKE;



  // ----------- KYBER MATHEMATICAL PRIMITIVES -------------

  /// H primitive from Kyber specification.
  ///
  /// Takes in a variable length byte array and returns its SHA3_256 hash.
  Uint8List _h(Uint8List message) {
    return sha3_256.convert(message).bytes;
  }

  /// KDF primitive from Kyber specification.
  ///
  /// Takes in a variable length byte array and returns a 32 byte SHAKE256 hash.
  Uint8List _kdf(Uint8List message) {
    return shake256.of(32).convert(message).bytes;
  }

  /// G primitive from Kyber specification.
  ///
  /// G takes in a variable length seed and returns
  /// its SHA3-512 hash split in two.
  (Uint8List lower32Bytes, Uint8List upper32Bytes) _g(Uint8List seed) {
    var bytes = sha3_512.convert(seed).bytes;
    return (bytes.sublist(0, 256), bytes.sublist(256));
  }

  /// Joins two byte arrays A and B together.
  ///
  /// returns <code>A || B</code>
  Uint8List _join(Uint8List A, Uint8List B) {
    var result = BytesBuilder();
    result.add(A);
    result.add(B);
    return result.toBytes();
  }







  // ----------- PUBLIC KEM API -------------

  /// A Kyber keypair is derived deterministically from a
  /// 64-octet seed.
  (PKEPublicKey pk, PKEPrivateKey sk, Uint8List encapsulationSeed) generateKeys(Uint8List seed) {
    if( seed.length != 64 ) {
      throw ArgumentError("Seed must be 64 bytes in length");
    }

    // This z will be used only when decryption has failed.
    var z = seed.sublist(32);

    // Generate PKE keys for decryption and encryption of cyphers.
    var (pk, sk) = innerPKE.generateKeys(seed.sublist(0, 32));

    return (pk, sk, z);
  }



  /// Kyber encapsulation takes a public key and a 32-octet seed
  /// and deterministically generates a shared secret and ciphertext
  /// for the public key.
  (PKECypher pkeCypher, Uint8List sharedSecret) encapsulate(PKEPublicKey pk, Uint8List seed) {
    if( seed.length != 32 ) {
      throw ArgumentError("Seed must be 32 bytes in length");
    }

    // Calculate hashes.
    var encapsulationSeedHash = _h(seed);
    var publicKeyHash = _h(pk.serialize());

    // Calculate seeds.
    var (sharedSecretSeed, pkeSeed) = _g( _join(encapsulationSeedHash, publicKeyHash) );

    // Encrypt the hash of the encapsulation seed.
    var pkeCypher = innerPKE.encrypt(pk, encapsulationSeedHash, pkeSeed);

    // Calculate cypher hash.
    var cypherHash = _h(pkeCypher.serialize());

    // Calculate shared secret.
    var sharedSecret = _kdf( _join(sharedSecretSeed, cypherHash) );

    return (pkeCypher, sharedSecret);
  }



  /// Kyber decapsulation takes the received cypher text from the other
  /// end and your public key, private key and 32-byte z value and
  /// returns a shared secret.
  ///
  /// - If decapsulation was successful, returns the shared key calculated in the
  /// encapsulation step.
  /// - If decapsulation was unsuccessful, returns an invalid shared key created
  /// with the given 32-byte z value calculated in the key-generation step.
  Uint8List decapsulate(PKEPublicKey pk, PKEPrivateKey sk, PKECypher cypher, Uint8List z) {

    // Calculate public key hash.
    var pkHash = _h(pk.serialize());

    // Decrypt the hash of the encapsulation seed.
    // This will be used to recreate the cypher.
    var encapsulationSeedHash2 = innerPKE.decrypt(sk, cypher);

    // Recreate the cypher.
    // This is done to check if received and recreated cypher are the same.
    // If they do not match, a transmission or decryption error has occurred.
    var (sharedSecretSeed2, pkeSeed2) = _g( _join(encapsulationSeedHash2, pkHash) );
    var cypher2 = innerPKE.encrypt(pk, encapsulationSeedHash2, pkeSeed2);

    // Calculate the received cypher hash.
    var cypherHash = _h(cypher.serialize());

    // Calculate the shared secret using received cypher.
    var sharedSecret = _kdf( _join(sharedSecretSeed2, cypherHash) );

    // Create a constant time invalid shared secret to return when decryption
    // fails in order to avoid timing attacks.
    var failedSharedSecret = _kdf( _join(z, cypherHash) );

    // If the received and recreated cyphers are equal,
    // this means that decryption was successful.
    //
    // WARNING: The implementation of this should be in constant time to
    // avoid timing attacks.
    if(cypher2 == cypher) {
      return sharedSecret;
    }
    return failedSharedSecret;
  }

}


