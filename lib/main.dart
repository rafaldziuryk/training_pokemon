import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/pokemon_detail.dart';
import 'package:pokemon/pokemon_model.dart';
import 'package:pokemon/search.dart';

late final Box<PokemonModel> pokemonsBox;

void main() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(PokemonModelAdapter().typeId)) {
    Hive.registerAdapter(PokemonModelAdapter());
  }
  pokemonsBox = await Hive.openBox('pokemons');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? search;
  List<PokemonModel> filteredPokemons = pokemonsBox.values.toList();

  final future = Future.delayed(
    Duration(seconds: 1),
    () async {
      final uri = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0");
      final response = await http.get(uri);
      return jsonDecode(response.body)["results"] as List;
    },
  );

  void filter() {
    final pokemons = pokemonsBox.values.toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              final pokemons = await future;
              final pokemonModels = pokemons.map((e) => PokemonModel(name: e["name"])).toList();
              pokemonsBox.clear();
              pokemonsBox.addAll(pokemonModels);
              setState(() {});
            },
            icon: Icon(Icons.download),
          ),
          IconButton(
            onPressed: () async {
              final value = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search(),));
              if (value != null) {
                setState(() {
                  search = value;
                });
              }
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: filteredPokemons.length,
        itemBuilder: (context, index) {
          final pokemon = filteredPokemons[index];
          return Dismissible(
            onDismissed: (direction) {
              pokemonsBox.deleteAt(index);
            },
            key: Key(pokemon.name),
            child: ListTile(
              trailing: IconButton(
                onPressed: () async {
                  final value = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PokemonDetail(),));
                  if (value != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
                  }
                },
                icon: Icon(Icons.add_circle),
              ),
              title: Text(pokemon.name),
              leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      imageUrl:
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png")),
            ),
          );
        },
      ),
    );
  }
}
