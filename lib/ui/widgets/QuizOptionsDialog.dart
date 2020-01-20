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
              Text("Select Total Number of Questions"),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: <Widget>[
                    ActionChip(
                      label: Text("10"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _noOfQuestions == 10
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectNumberOfQuestions(10),
                    ),
                    ActionChip(
                      label: Text("20"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _noOfQuestions == 20
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectNumberOfQuestions(20),
                    ),
                    ActionChip(
                      label: Text("30"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _noOfQuestions == 30
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectNumberOfQuestions(30),
                    ),
                    ActionChip(
                      label: Text("40"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _noOfQuestions == 40
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectNumberOfQuestions(40),
                    ),
                    ActionChip(
                      label: Text("50"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _noOfQuestions == 50
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectNumberOfQuestions(50),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text("Select Difficulty"),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 16.0,
                  spacing: 16.0,
                  children: <Widget>[
                    SizedBox(width: 0.0),
                    ActionChip(
                      label: Text("Any"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _difficulty == null
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectDifficulty(null),
                    ),
                    ActionChip(
                      label: Text("Easy"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _difficulty == "easy"
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectDifficulty("easy"),
                    ),
                    ActionChip(
                      label: Text("Medium"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _difficulty == "medium"
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectDifficulty("medium"),
                    ),
                    ActionChip(
                      label: Text("Hard"),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      backgroundColor: _difficulty == "hard"
                          ? Colors.indigo
                          : Colors.grey.shade600,
                      onPressed: () => _selectDifficulty("hard"),
                    ),
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorScreen(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            questions: questions,
            category: widget.category,
          ),
        ),
      );
    } on SocketException catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message:
                "Can't reach the servers, \n Please check your internet connection.",
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
    setState(() {
      processing = false;
    });
  }
}
