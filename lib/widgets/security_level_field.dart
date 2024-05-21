enum KyberSecurityLevel {
  level2,
  level3,
  level4
}

// class KyberSecurityLevelField extends StatelessWidget {
//   const KyberSecurityLevelField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ConstrainedBox(
//       constraints: const BoxConstraints.tightFor(width: 310),
//       child: SegmentedButton<KeyFieldAction>(
//           selected: <KeyFieldAction>{widget.selected},
//           onSelectionChanged: (newSelection) {
//             if (widget.onSelectionChanged != null) {
//               widget.onSelectionChanged!(newSelection.first);
//             }
//           },
//           segments: const [
//             ButtonSegment(value: KeyFieldAction.generate, label: Text("Generate")),
//             ButtonSegment(value: KeyFieldAction.useExisting, label: Text("Use existing")),
//           ]),
//     );
//   }
// }

enum DilithiumSecurityLevel {
  level2,
  level3,
  level5
}

// class DilithiumSecurityLevelField extends StatelessWidget {
//   const DilithiumSecurityLevelField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SegmentedButton<DilithiumSecurityLevel>(
//       selected: <DilithiumSecurityLevel>{_securityLevel},
//       onSelectionChanged: (newSelection) {
//         setState(() {
//           _securityLevel = newSelection.first;
//         });
//       },
//       segments: const [
//         ButtonSegment(value: DilithiumSecurityLevel.level2, label: Text("Level 2")),
//         ButtonSegment(value: DilithiumSecurityLevel.level3, label: Text("Level 3")),
//         ButtonSegment(value: DilithiumSecurityLevel.level5, label: Text("Level 5")),
//       ]
//     );
//   }
//
// }