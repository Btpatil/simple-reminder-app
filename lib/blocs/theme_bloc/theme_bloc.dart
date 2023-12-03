import 'package:flutter_application_1/blocs/theme_bloc/theme_event.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_state.dart';
import 'package:flutter_application_1/theme/theme_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  String theme = "";
  ThemeBloc() : super(SystemTheme()) {
    on<InitalThemeEvent>((event, emit) async {
      // print("$emit $event");
      theme = await getThemeMode();
      print("theme bloc 12 $theme");
      if (theme == "ThemeMode.system") {
        print("theme bloc 14 $theme");
        return emit(SystemTheme());
      } else if (theme == "ThemeMode.dark") {
        print("theme bloc 17 $theme");
        return emit(DarkTheme());
      }
      return emit(LightTheme());
    });

    on<ThemeChangeEvent>((event, emit) async {
      print("theme bloc 24 $event");
      theme = await setTheme(event.changeToTheme);
      print("theme bloc 26 $theme");
      if (theme == "ThemeMode.system") {
        print("theme bloc 28 $theme");
        return emit(SystemTheme());
      } else if (theme == "ThemeMode.dark") {
        print("theme bloc 31 $theme");
        return emit(DarkTheme());
      }
      return emit(LightTheme());
    });

    // if (theme == "") {
    //   add(ThemeChangeEvent());
    // }
  }
}
