enum Type { multiple, boolean }

enum Difficulty { easy, medium, hard }

class QuestionModel {
  final String categoryName;
  final Type type;
  final Difficulty difficulty;
  final String question;
  final String correctAnswer;
  final List<dynamic> incorrectAnswers;

  QuestionModel({
    this.categoryName,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers,
  });

  QuestionModel.fromMap(Map<String, dynamic> data)
      : categoryName = data["category"],
        type = data["type"] == "multiple" ? Type.multiple : Type.boolean,
        difficulty = data["difficulty"] == "easy"
            ? Difficulty.easy
            : data["difficulty"] == "medium"
                ? Difficulty.medium
                : Difficulty.hard,
        question = data["question"],
        correctAnswer = data["correct_answer"],
        incorrectAnswers = data["incorrect_answers"];

  static List<QuestionModel> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => QuestionModel.fromMap(question)).toList();
  }
}
