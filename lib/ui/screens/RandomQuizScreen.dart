import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_app/models/CategoryModel.dart';
import 'package:quiz_app/models/OptionModel.dart';
import 'dart:io';
import 'package:quiz_app/models/QuestionModel.dart';
import 'package:quiz_app/resources/ApiProvider.dart';
import 'package:quiz_app/ui/screens/ErrorScreen.dart';
import 'package:quiz_app/ui/screens/QuizFinishedScreen.dart';
import 'package:quiz_app/ui/widgets/AnimatedProgressbar.dart';
import 'package:quiz_app/ui/widgets/ClipShadowPath.dart';

class RandomQuizScreen extends StatefulWidget {
  @override
  _RandomQuizScreenState createState() => _RandomQuizScreenState();
}

class _RandomQuizScreenState extends State<RandomQuizScreen> {
  bool _isLoading = false;
  List<QuestionModel> _questions = [];

  final TextStyle _questionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _length = 0;
  double _height = 0.0;
  List<dynamic> options;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      _height = MediaQuery.of(context).size.height;
      QuestionModel question = _questions[_currentIndex];
      options = question.incorrectAnswers;
      if (!options.contains(question.correctAnswer)) {
        options.add(question.correctAnswer);
        options.shuffle();
      }
    }

    return Scaffold(
      key: _key,
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                height: _height,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    ClipShadowPath(
                      shadow: Shadow(
                        blurRadius: 5,
                        offset: Offset(0, 0.2),
                        color: Colors.grey.shade400,
                      ),
                      clipper: WaveClipperOne(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        height: _height / 3.5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              AnimatedProgressbar(
                                  value: (_currentIndex + 1) / _length),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Text(
                                      "${_currentIndex + 1}",
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      HtmlUnescape().convert(
                                        _questions[_currentIndex].question,
                                      ),
                                      softWrap: true,
                                      style: _questionStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _height / 4),
                      child: Transform.rotate(
                        angle: pi,
                        child: ClipShadowPath(
                          shadow: Shadow(
                            blurRadius: 5,
                            offset: Offset(0, 0.2),
                            color: Colors.grey.shade400,
                          ),
                          clipper: WaveClipperOne(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            height: _height - _height / 3.5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: _height / 3),
                      padding: EdgeInsets.all(16),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options.map(
                              (option) => RadioListTile(
                                title: Text(HtmlUnescape().convert("$option")),
                                groupValue: _answers[_currentIndex],
                                value: option,
                                onChanged: (value) {
                                  setState(() {
                                    _answers[_currentIndex] = option;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          child: Text(
                            _currentIndex == (_length - 1) ? "Submit" : "Next",
                          ),
                          onPressed: _nextSubmit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "You must select an answer to continue.",
          ),
        ),
      );
      return;
    }
    if (_currentIndex < (_length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizFinishedScreen(
            questions: _questions,
            answers: _answers,
            optionModel: OptionModel(
              category: CategoryModel(0, 'Random', Icons.all_inclusive),
              difficulty: 'Any',
              noOfQuestions: 10,
              type: 'Any',
            ),
          ),
        ),
      );
    }
  }

  void _loadQuiz() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<QuestionModel> questions = await getRandomQuestions();
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
      _questions = questions;
      _length = questions.length;
      setState(() {
        _isLoading = false;
      });
      return;
    } on SocketException catch (_) {
      print('on socket exception');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ErrorScreen(
            message:
                "Can't reach the server, \n Please check your internet connection.",
          ),
        ),
      );
    } catch (e) {
      print('error');
      print(e.message);
      Navigator.push(
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
