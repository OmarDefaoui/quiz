import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryModel {
  final int id;
  final String name;
  final dynamic icon;
  CategoryModel(this.id, this.name, this.icon);
}

final List<CategoryModel> categories = [
  CategoryModel(9, "General Knowledge", FontAwesomeIcons.globeAsia),
  CategoryModel(10, "Books", FontAwesomeIcons.bookOpen),
  CategoryModel(11, "Film", FontAwesomeIcons.video),
  CategoryModel(12, "Music", FontAwesomeIcons.music),
  CategoryModel(13, "Musicals & Theatres", FontAwesomeIcons.theaterMasks),
  CategoryModel(14, "Television", FontAwesomeIcons.tv),
  CategoryModel(15, "Video Games", FontAwesomeIcons.gamepad),
  CategoryModel(16, "Board Games", FontAwesomeIcons.chessBoard),
  CategoryModel(17, "Science & Nature", FontAwesomeIcons.microscope),
  CategoryModel(18, "Computer", FontAwesomeIcons.laptopCode),
  CategoryModel(19, "Maths", FontAwesomeIcons.sortNumericDown),
  CategoryModel(20, "Mythology", FontAwesomeIcons.personBooth),
  CategoryModel(21, "Sports", FontAwesomeIcons.footballBall),
  CategoryModel(22, "Geography", FontAwesomeIcons.mountain),
  CategoryModel(23, "History", FontAwesomeIcons.monument),
  CategoryModel(24, "Politics", FontAwesomeIcons.book),
  CategoryModel(25, "Art", FontAwesomeIcons.paintBrush),
  CategoryModel(26, "Celebrities", FontAwesomeIcons.layerGroup),
  CategoryModel(27, "Animals", FontAwesomeIcons.dog),
  CategoryModel(28, "Vehicles", FontAwesomeIcons.carAlt),
  CategoryModel(29, "Comics", FontAwesomeIcons.teeth),
  CategoryModel(30, "Gadgets", FontAwesomeIcons.mobileAlt),
  CategoryModel(31, "Japanese Anime & Manga", FontAwesomeIcons.bookReader),
  CategoryModel(32, "Cartoon & Animation", FontAwesomeIcons.adobe),
];
