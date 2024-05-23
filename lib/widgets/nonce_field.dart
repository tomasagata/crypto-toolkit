// import 'package:flutter/material.dart';
//
// class NonceField extends StatelessWidget {
//   NonceField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return TextFormField(
//       autocorrect: false,
//       maxLines: 1,
//       enableSuggestions: false,
//       onChanged: (nonce) {
//         print(nonce);
//         try {
//           Uint8List nonceBytes = base64Decode(nonce);
//           print(utf8.decode(nonceBytes));
//           setState(() {
//             _nonce = nonceBytes;
//             _nonceError = false;
//           });
//         } catch (error) {
//           print(error);
//           setState(() {
//             _nonce = null;
//             _nonceError = true;
//           });
//         }
//       },
//       decoration: InputDecoration(
//           error: _nonceError ? const Text("Nonce must be in base64") : null,
//           border: const OutlineInputBorder(),
//           label: const Text("nonce (hexadecimal)"),
//           constraints: const BoxConstraints(
//             minWidth: 0.0,
//             maxWidth: 400,
//             minHeight: 0.0,
//             maxHeight: 200,
//           ),
//           alignLabelWithHint: true
//       ),
//     );
//   }
//
// }