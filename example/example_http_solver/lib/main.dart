import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_solver/http_solver.dart';

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
    widget._data =
        await HttpSolver.getFromApi(Post(), widget.url, checkInternet: true)
            .toEither();
    setState(() {});
  }
}

class Post implements BaseModelForHttpSolver {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    this.id,
    this.userId,
    this.title,
    this.body,
  });

  Post fromJson(String source) {
    Map<String, dynamic> jsonData = (json.decode(source));
    if (jsonData == null) return null;
    return Post(
      id: jsonData['id'],
      userId: jsonData['userId'],
      title: jsonData['title'],
      body: jsonData['body'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    //  return json.encode([this.id, this.userId, this.title]);//Converts [value] to a JSON string.
    final Map<String, dynamic> data = HashMap<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
