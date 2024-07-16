import 'package:flutter/material.dart';

class gradientUtils {
  static LinearGradient getLinearGradient({
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    List<Color> colors = const [
      Color.fromARGB(255, 207, 200, 174),
      Color.fromARGB(255, 53, 32, 31),
      Color.fromARGB(255, 112, 84, 67),
      Color.fromARGB(255, 153, 115, 92),
      Color.fromARGB(255, 177, 136, 110),
      Color.fromARGB(255, 221, 208, 163),
    ],
    List<double> stops = const [0.1, 0.2, 0.4, 0.6, 0.8, 1.0],
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors, stops: stops);
  }

  static LinearGradient getLinearGradient2({
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    List<Color> colors = const [
      Color.fromARGB(255, 128, 0, 255),
      Color.fromRGBO(181, 102, 246, 1),
      Color.fromARGB(255, 128, 0, 255)
    ],
    List<double> stops = const [0.2, 0.5, 1.0],
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors, stops: stops);
  }
}
