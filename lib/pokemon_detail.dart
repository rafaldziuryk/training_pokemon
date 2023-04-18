import 'package:flutter/material.dart';

class PokemonDetail extends StatelessWidget {
  const PokemonDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop("Rafał"),
      ),
    );
  }
}
