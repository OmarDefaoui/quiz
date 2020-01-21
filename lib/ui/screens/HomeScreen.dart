import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/CategoriesScreen.dart';
import 'package:quiz_app/ui/screens/RandomQuizScreen.dart';
import 'package:quiz_app/ui/widgets/CustomAppBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _currentTab = 0;
  static var _tabPages = <Widget>[
    CategoriesScreen(),
    RandomQuizScreen(),
  ];
  static var _tabs = <TabData>[
    TabData(
      iconData: Icons.category,
      title: "Categories",
    ),
    TabData(
      iconData: Icons.all_inclusive,
      title: "Random",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _showActionBarTitle(),
      ),
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        controller: _pageController,
        children: _tabPages,
      ),
      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: _currentTab,
        tabs: _tabs,
        barBackgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        circleColor: Theme.of(context).accentColor,
        inactiveIconColor: Colors.white,
        onTabChangedListener: (position) {
          _pageController.animateToPage(
            position,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }

  String _showActionBarTitle() {
    if (_currentTab == 0)
      return "Categories";
    else
      return "Random";
  }
}
