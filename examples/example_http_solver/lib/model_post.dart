import 'dart:collection';
import 'dart:convert';
import 'package:http_solver/http_solver.dart';

class Post extends BaseModelForHttpSolver {
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

  @override
  String toString() {
    return 'Post id: $id, userId: $userId, title: $title, body: $body';
  }
}
