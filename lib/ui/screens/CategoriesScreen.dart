import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz/models/CategoryModel.dart';
import 'package:quiz/ui/widgets/QuizOptionsDialog.dart';
import 'package:quiz/utilities/InterstitialAd.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  BannerAd _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  @override
  void initState() {
    super.initState();
    _initAds();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
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
      child: Column(
        children: [
          bannerAdBox(),
          Expanded(
            child: CustomScrollView(
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
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    CategoryModel category = categories[index];
    return MaterialButton(
      elevation: 4,
      highlightElevation: 1,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800.withOpacity(0.8),
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(category.icon),
          SizedBox(height: 10.0),
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

  _initAds() {
    _bannerAd = createBannerAd(
      onLoad: (BannerAd ad) => bannerCompleter.complete(ad),
    )..load();
  }

  Widget bannerAdBox() {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            print('mad active');
            child = SizedBox.shrink();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              print('mad goooood');
              child = Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              );
            } else {
              print('mad else');
              child = SizedBox.shrink();
            }
        }

        return child;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
