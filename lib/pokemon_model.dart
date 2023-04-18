import 'package:hive_flutter/hive_flutter.dart';

part 'pokemon_model.g.dart';

@HiveType(typeId: 1)
class PokemonModel {
  @HiveField(0)
  final String name;

  const PokemonModel({
    required this.name,
  });
}
