import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/OptionModel.dart';
import 'package:quiz_app/models/QuestionModel.dart';

const String baseUrl = "https://opentdb.com/api.php";

Future<List<QuestionModel>> getQuestions(OptionModel optionModel) async {
  int total = optionModel.noOfQuestions;
  int categoryId = optionModel.category.id;
  String difficulty = optionModel.difficulty;
  String type = optionModel.type;

  String url = "$baseUrl?amount=$total&category=$categoryId";
  if (difficulty != null) {
    url = "$url&difficulty=$difficulty";
  }
  if (type != null) {
    url = "$url&type=$type";
  }
  print(url);

  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return QuestionModel.fromData(questions);
}

Future<List<QuestionModel>> getRandomQuestions() async {

  String url = "$baseUrl?amount=10";
  print(url);

  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return QuestionModel.fromData(questions);
}

