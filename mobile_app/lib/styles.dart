/* Date: 21st of Jun 2025 */

// import basic ui components
import 'package:flutter/material.dart';

// union app bar style
AppBar appBar(String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
  );
}

// Const styles for better performance
const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
const EdgeInsets smallPadding = EdgeInsets.all(8.0);
const EdgeInsets largePadding = EdgeInsets.all(24.0);

const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(10));
const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(16));

const TextStyle titleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.blueGrey,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.blueGrey,
);
