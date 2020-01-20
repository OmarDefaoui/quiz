import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/CategoryModel.dart';
import 'package:quiz_app/models/QuestionModel.dart';

const String baseUrl = "https://opentdb.com/api.php";

Future<List<QuestionModel>> getQuestions(
    CategoryModel category, int total, String difficulty) async {
  String url = "$baseUrl?amount=$total&category=${category.id}";
  if (difficulty != null) {
    url = "$url&difficulty=$difficulty";
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return QuestionModel.fromData(questions);
}
