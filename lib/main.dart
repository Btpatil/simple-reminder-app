import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_event.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_state.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/provider/themeprovider.dart';
import 'package:flutter_application_1/service/notifyservice.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:flutter_application_1/ui/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // timezone initalization
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  // flutter local notification initialization
  NotificationService().initalizeNotification();

  // hive initalization
  await Hive.initFlutter();
  await Hive.openBox('Reminders');
  await Hive.openBox('themeMode');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Reminders()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ThemeBloc>(context).add(InitalThemeEvent());
    ThemeMode? themeMode;
    // print("main 52 $themeMode");
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        print("main 56 $state ");
        if (state is SystemTheme) {
          themeMode = ThemeMode.system;
        } else if (state is DarkTheme) {
          themeMode = ThemeMode.dark;
        } else {
          themeMode = ThemeMode.light;
        }
        print("main 65 $themeMode ");

        return MaterialApp(
          title: 'Remind Me',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          // Provider.of<ThemeProvider>(context).themeMode
          //     ? ThemeMode.light
          //     : ThemeMode.dark,
          home: const HomePage(),
        );
      },
    );
  }
}
