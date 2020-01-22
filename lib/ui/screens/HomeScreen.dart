import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:quiz/Constants/ApiKey.dart';
import 'package:quiz/ui/screens/CategoriesScreen.dart';
import 'package:quiz/ui/screens/RandomQuizScreen.dart';
import 'package:quiz/ui/widgets/CustomAppBar.dart';
import 'package:quiz/utilities/InterstitialAd.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static PageController _pageController;
  int _currentTab = 0;
  static var _tabPages = <Widget>[
    CategoriesScreen(),
    RandomQuizScreen(
      goToCategoriesScreen: () {
        FancyBottomNavigationState fState = bottomNavigationKey.currentState;
        fState.setPage(0);
      },
    ),
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
  static GlobalKey bottomNavigationKey = GlobalKey();

  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _initAds();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _interstitialAd?.dispose();
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
        key: bottomNavigationKey,
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

  _initAds() {
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAdMob.instance.initialize(appId: admobAppId);
      _interstitialAd = createInterstitialAd(1)
        ..load()
        ..show();
    });
  }
}
