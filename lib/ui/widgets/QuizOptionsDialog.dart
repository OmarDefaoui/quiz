import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/CategoryModel.dart';
import 'package:quiz_app/models/QuestionModel.dart';
import 'package:quiz_app/resources/ApiProvider.dart';
import 'package:quiz_app/ui/screens/ErrorScreen.dart';
import 'package:quiz_app/ui/screens/QuizScreen.dart';

class QuizOptionsDialog extends StatefulWidget {
  final CategoryModel category;

  const QuizOptionsDialog({this.category});

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int _noOfQuestions;
  String _difficulty;
  bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
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
                  style: Theme.of(context).textTheme.title.copyWith(),
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
              processing
                  ? CircularProgressIndicator()
                  : RaisedButton(
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
          _noOfQuestions == number ? Colors.indigo : Colors.grey.shade600,
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
          _difficulty == difficulty ? Colors.indigo : Colors.grey.shade600,
      onPressed: () => _selectDifficulty(difficulty),
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

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<QuestionModel> questions =
          await getQuestions(widget.category, _noOfQuestions, _difficulty);
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
            category: widget.category,
            difficulty: _difficulty,
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
