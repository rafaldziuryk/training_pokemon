import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pop(controller.text);
            }, child: Text("Search")),
          ],
        ),
      ),
    );
  }
}
