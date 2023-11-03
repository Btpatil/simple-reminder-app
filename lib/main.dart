import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/service/notifyservice.dart';
import 'package:flutter_application_1/ui/homepage.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Reminders()),
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
    return MaterialApp(
      title: 'Remind Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
