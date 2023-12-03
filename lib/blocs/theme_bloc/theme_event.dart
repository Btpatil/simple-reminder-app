// part of 'theme_bloc.dart';

// @immutable
import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class InitalThemeEvent extends ThemeEvent {}

class ThemeChangeEvent extends ThemeEvent {
  final ThemeMode changeToTheme;

  ThemeChangeEvent({required this.changeToTheme});
}
