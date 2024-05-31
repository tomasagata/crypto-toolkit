import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/abstractions/kem_private_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/abstractions/kem_public_key.dart';
import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';

class KyberFlowDetails {
  const KyberFlowDetails({
    required this.securityLevel,
    required this.publicKey,
    required this.privateKey,
    required this.nonce
  });

  final KyberSecurityLevel securityLevel;
  final KemPrivateKey privateKey;
  final KemPublicKey publicKey;
  final Uint8List nonce;

}