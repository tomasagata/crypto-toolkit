import 'dart:typed_data';

import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_private_key.dart';
import 'package:crypto_toolkit/algorithms/kyber/abstractions/pke_public_key.dart';
import 'package:crypto_toolkit/widgets/security_level_field.dart';

class KyberFlowDetails {
  const KyberFlowDetails({
    required this.securityLevel,
    required this.publicKey,
    required this.privateKey,
    required this.nonce
  });

  final KyberSecurityLevel securityLevel;
  final PKEPrivateKey privateKey;
  final PKEPublicKey publicKey;
  final Uint8List nonce;

}