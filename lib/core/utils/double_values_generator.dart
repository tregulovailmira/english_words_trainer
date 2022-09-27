import 'dart:math';

final random = Random();

double getRandom(double min, double max) =>
    random.nextDouble() * (max - min) + min;
