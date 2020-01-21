import 'package:quiz_app/models/CategoryModel.dart';

class OptionModel {
  final String difficulty, type;
  final int noOfQuestions;
  final CategoryModel category;

  OptionModel({
    this.category,
    this.noOfQuestions,
    this.difficulty,
    this.type,
  });
}
