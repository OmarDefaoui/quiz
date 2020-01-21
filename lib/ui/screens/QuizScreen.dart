import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_app/models/OptionModel.dart';
import 'package:quiz_app/models/QuestionModel.dart';
import 'package:quiz_app/ui/screens/QuizFinishedScreen.dart';
import 'package:quiz_app/ui/widgets/AnimatedProgressbar.dart';
import 'package:quiz_app/ui/widgets/ClipShadowPath.dart';
import 'package:quiz_app/ui/widgets/CustomAppBar.dart';

class QuizScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  final OptionModel optionModel;

  const QuizScreen({
    @required this.questions,
    @required this.optionModel,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextStyle _questionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int length;

  @override
  void initState() {
    super.initState();
    length = widget.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    QuestionModel question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: CustomAppBar(
          title: widget.optionModel.category.name,
        ),
        body: Container(
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
                            value: (_currentIndex + 1) / length),
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
                                  widget.questions[_currentIndex].question,
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
                    child: Text(_currentIndex == (widget.questions.length - 1)
                        ? "Submit"
                        : "Next"),
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
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizFinishedScreen(
            questions: widget.questions,
            answers: _answers,
            optionModel: widget.optionModel,
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning !"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
