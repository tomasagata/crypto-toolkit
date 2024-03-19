import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(7.0, 10.0, 7.0, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            child: ListView(
              children: const [
                Placeholder(fallbackHeight: 100),
                Placeholder(fallbackHeight: 100),
                Placeholder(fallbackHeight: 100),
                Placeholder(fallbackHeight: 100),
                Placeholder(fallbackHeight: 100),
                Placeholder(fallbackHeight: 100),
              ]
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text("Cancelar")),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Guardar"))
            ],
          )
        ],
      ),
    );
  }

}