import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quiz/models/OptionModel.dart';
import 'package:quiz/models/QuestionModel.dart';
import 'package:quiz/ui/screens/CheckAnswersScreen.dart';
import 'package:quiz/ui/widgets/CustomAppBar.dart';

class QuizFinishedScreen extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<int, dynamic> answers;
  final OptionModel optionModel;

  QuizFinishedScreen({
    @required this.questions,
    @required this.answers,
    @required this.optionModel,
  });

  final TextStyle titleStyle = TextStyle(
    color: Colors.black87,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );
  final TextStyle trailingStyle = TextStyle(
    color: Colors.blue,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  double _height;

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    this.answers.forEach((index, value) {
      if (this.questions[index].correctAnswer == value) correct++;
    });
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Result',
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _detailCard(
                  title: 'Total questions', detail: '${questions.length}'),
              _detailCard(
                  title: 'Category', detail: '${optionModel.category.name}'),
              _detailCard(title: 'Difficulty', detail: '${_getDifficulty()}'),
              _detailCard(title: 'Type', detail: '${_getType()}'),
              _detailCard(
                  title: 'Score',
                  detail:
                      '${(correct / questions.length * 100).toStringAsPrecision(3)}%'),
              _detailCard(
                  title: 'Correct answers',
                  detail: '$correct/${questions.length}'),
              _detailCard(
                  title: 'Incorrect answers',
                  detail: '${questions.length - correct}/${questions.length}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Theme.of(context).accentColor.withOpacity(0.8),
                    child: Text("Home"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text("Check answers"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CheckAnswersScreen(
                            questions: questions,
                            answers: answers,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailCard({String title, String detail}) {
    return Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: _height * 0.13,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  style: titleStyle,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(left: 20),
                    child: AutoSizeText(
                      detail,
                      style: trailingStyle,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  String _getDifficulty() {
    switch (optionModel.difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return 'Any';
    }
  }

  String _getType() {
    switch (optionModel.type) {
      case 'multiple':
        return 'Multiple choice';
      case 'boolean':
        return 'True / false';
      default:
        return 'Any';
    }
  }
}
