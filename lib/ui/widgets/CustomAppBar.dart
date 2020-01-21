import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Constants/Constants.dart';
import 'package:quiz_app/models/PopUpMenuItems.dart';
import 'package:share/share.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar({Key key, this.title})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      centerTitle: false,
      backgroundColor: Colors.blue,
      actions: <Widget>[
        PopupMenuButton<PopUpMenuItems>(
          onSelected: (item) {
            showAction(item.title);
          },
          itemBuilder: (BuildContext context) {
            return popUpMenuItems.map((PopUpMenuItems item) {
              return PopupMenuItem<PopUpMenuItems>(
                value: item,
                child: Row(
                  children: <Widget>[
                    Icon(
                      item.icon,
                      color: Colors.lightBlue,
                    ),
                    SizedBox(width: 10),
                    Text(item.title),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  showAction(String title) async {
    switch (title) {
      case 'More apps':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: myPlayStoreLink,
          );
          await intent.launch();
        }
        break;
      case 'Share':
        Share.share(
          shareBody,
          subject: shareSubject,
        );
        break;
      case 'Rate':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: appPlayStoreLink,
          );
          await intent.launch();
        }
        break;
      case 'Privacy policy':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: appPrivacyPolicyLink,
          );
          await intent.launch();
        }
        break;
    }
  }
}
