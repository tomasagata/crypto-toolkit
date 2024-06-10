import 'dart:typed_data';

import 'package:crypto_toolkit/widgets/fields/security_level_field.dart';
import 'package:post_quantum/post_quantum.dart';

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