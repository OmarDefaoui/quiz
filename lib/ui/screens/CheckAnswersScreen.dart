import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/models/QuestionModel.dart';
import 'package:quiz/ui/widgets/ClipShadowPath.dart';
import 'package:quiz/ui/widgets/CustomAppBar.dart';

class CheckAnswersScreen extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersScreen({@required this.questions, @required this.answers});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Check Answers',
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            ClipShadowPath(
              shadow: Shadow(
                blurRadius: 5,
                offset: Offset(0, 0.2),
                color: Colors.grey.shade400,
              ),
              clipper: OvalBottomBorderClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                height: _height / 3.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _height - _height / 3.5),
              child: ClipShadowPath(
                shadow: Shadow(
                  blurRadius: 5,
                  offset: Offset(0, 0.2),
                  color: Colors.grey.shade400,
                ),
                clipper: OvalTopBorderClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: questions.length + 1,
              itemBuilder: _buildItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: RaisedButton(
          child: Text("Done"),
          onPressed: () {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
          },
        ),
      );
    }
    QuestionModel question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      color: Colors.white.withOpacity(0.96),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.question),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              HtmlUnescape().convert("${answers[index]}"),
              style: TextStyle(
                color: correct ? Colors.green : Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            correct
                ? SizedBox.shrink()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Answer: "),
                      TextSpan(
                        text: HtmlUnescape().convert(question.correctAnswer),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  ),
          ],
        ),
      ),
    );
  }
}
