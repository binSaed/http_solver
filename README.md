# http_solver
---

A package help you to make api call and handle error faster, also you can check for internet before call api.

## Make your model

**BaseModelForHttpSolver** is a abstract class, your model should `implements` it.
```dart
class YourModel implements BaseModelForHttpSolver{}
```

## get data from your api
**getFromApi** static method take `YourModel` and `your Api url` and return Future<YourModel> and it is have some option parameter `checkInternet`, `headers` for Api.

```dart
YourModel dataInModel = await HttpSolver.getFromApi(YourModel(), apiUrl, checkInternet: true);
```

## convert model to either
**toEither()** extension on Future<yourModel> to handle all error and return `Either<Failure, YourModel>`.

```dart
Future<YourModel> dataInModel =  HttpSolver.getFromApi(YourModel(), apiUrl, checkInternet: true);
Either<Failure, YourModel> modelOrError= dataInModel.toEither();
```

## Using Either With UI
```dart
modelOrError.fold((failure) => Text("${failure.message}"), //if has error show Text with failure message
(model) => Text(post.title)), //else show Text data
```

### Full [Example](https://github.com/AbdOoSaed/http_solver/tree/master/example/example_http_solver)

```dart
       import 'dart:collection';
       import 'dart:convert';
       import 'package:flutter/material.dart';
       import 'package:http_solver/http_solver.dart';

       void main() => runApp(MyApp());

       class MyApp extends StatelessWidget {
         @override
         Widget build(BuildContext context) {
           return MaterialApp(
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
               floatingActionButton:
                   FloatingActionButton(onPressed: _getEither, child: Text('Get')),
               body: Center(
                 child: (widget._data == null)
                     ? Text('No Data Yet')
                     : widget._data.fold((failure) => Text("${failure.message}"),
                         (post) => Text(post.title)),
               ));
         }

         void _getEither() async {
           widget._data =        await HttpSolver.getFromApi(Post(), widget.url, checkInternet: true).toEither();
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
           final Map<String, dynamic> data = HashMap<String, dynamic>();
           data['id'] = this.id;
           data['userId'] = this.userId;
           data['title'] = this.title;
           data['body'] = this.body;
           return data;
         }
       }
```

### Developer

- [AbdOo Saed](https://github.com/AbdOoSaed)
