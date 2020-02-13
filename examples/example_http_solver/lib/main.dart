import 'package:flutter/material.dart';
import 'package:http_solver/http_solver.dart';

import 'model_post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
 Either<Failure, Post> _data;
  final url = "http://www.mocky.io/v2/5e3c29393000009c2e214bf8";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _getApi),
      body: Center(
        child: (widget._data == null)
            ? Container(color: Colors.amber)
            : widget._data.fold((failure) => Text("${failure.message}"),
                (post) => Text(post.title)),
      ),
    );
  }

  void _getApi() async {
    widget._data = await HttpSolver.getFromApi(Post(), widget.url, checkInternet: true)
        .toEither();
    setState(() {});
  }
}
