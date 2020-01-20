import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz_app/models/CategoryModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quiz_app/ui/widgets/QuizOptionsDialog.dart';

class HomeScreen extends StatelessWidget {
  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  height: _height / 3,
                ),
              ),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: categories.length,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    CategoryModel category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(category.icon),
          SizedBox(height: 5.0),
          AutoSizeText(
            category.name,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(category: category),
        onClosing: () {},
      ),
    );
  }
}
