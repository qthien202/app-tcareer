import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

Reaction<String> reactionItemWidget(
    {required String value,
    required String title,
    required Color color,
    required String icon}) {
  return Reaction<String>(
      value: value,
      title: Text(
        " $title",
        style:
            TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w400),
      ),
      icon: reactionIcon(icon: icon));
}

Widget reactionIcon({
  required String icon,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        textAlign: TextAlign.center,
        icon,
        style: const TextStyle(fontSize: 20),
      ),
    ],
  );
}
