import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz/models/CategoryModel.dart';
import 'package:quiz/models/OptionModel.dart';
import 'package:quiz/models/QuestionModel.dart';
import 'package:quiz/ui/widgets/CustomRoundedButton.dart';
import 'package:quiz/utilities/ApiProvider.dart';
import 'package:quiz/ui/screens/ErrorScreen.dart';
import 'package:quiz/ui/screens/QuizScreen.dart';

class QuizOptionsDialog extends StatefulWidget {
  final CategoryModel category;

  const QuizOptionsDialog({this.category});

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int _noOfQuestions;
  String _difficulty;
  String _type;
  bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    _type = null;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey.shade200,
                child: Text(
                  widget.category.name,
                  style: Theme.of(context).textTheme.headline6.copyWith(),
                ),
              ),
              SizedBox(height: 10.0),
              Text("Select number of questions"),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: <Widget>[
                    _questionActionChip(10),
                    _questionActionChip(20),
                    _questionActionChip(30),
                    _questionActionChip(40),
                    _questionActionChip(50),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text("Select difficulty"),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: <Widget>[
                    _difficultyActionChip('Any', null),
                    _difficultyActionChip('Easy', 'easy'),
                    _difficultyActionChip('Medium', 'medium'),
                    _difficultyActionChip('Hard', 'hard'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text("Select type"),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: <Widget>[
                    _typeActionChip('Any', null),
                    _typeActionChip('Multiple choice', 'multiple'),
                    _typeActionChip('True / false', 'boolean'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              processing
                  ? CircularProgressIndicator()
                  : CustomRoundedButton(
                      child: Text("Start Quiz"),
                      onPressed: _startQuiz,
                    ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionActionChip(int number) {
    return ActionChip(
      label: Text("$number"),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor:
          _noOfQuestions == number ? Colors.blue : Colors.grey.shade500,
      onPressed: () => _selectNumberOfQuestions(number),
    );
  }

  Widget _difficultyActionChip(String text, String difficulty) {
    return ActionChip(
      label: Text(text),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor:
          _difficulty == difficulty ? Colors.blue : Colors.grey.shade500,
      onPressed: () => _selectDifficulty(difficulty),
    );
  }

  Widget _typeActionChip(String text, String type) {
    return ActionChip(
      label: Text("$text"),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor: _type == type ? Colors.blue : Colors.grey.shade500,
      onPressed: () => _selectType(type),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  _selectType(String t) {
    setState(() {
      _type = t;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    OptionModel _optionModel = OptionModel(
      category: widget.category,
      noOfQuestions: _noOfQuestions,
      difficulty: _difficulty,
      type: _type,
    );
    try {
      List<QuestionModel> questions = await getQuestions(_optionModel);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ErrorScreen(
              message:
                  "There are not enough questions in the category, with the options you selected.",
            ),
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            questions: questions,
            optionModel: _optionModel,
          ),
        ),
      );
    } on SocketException catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message:
                "Can't reach the server, \n Please check your internet connection.",
          ),
        ),
      );
    } catch (e) {
      print(e.message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message: "Unexpected error",
          ),
        ),
      );
    }
  }
}
