import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_event.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_state.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/service/notifyservice.dart';
import 'package:flutter_application_1/ui/bottomsheet.dart';
import 'package:flutter_application_1/ui/notificationscreen.dart';
import 'package:flutter_application_1/ui/reminder_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSelected = false;
  List selectedItemsIDs = [];

  changeSelectedState() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  clearSelectedList() {
    selectedItemsIDs.clear();
    setState(() {});
  }

//  to listen to any notification clicked or not
  listenToNotifications() {
    debugPrint("Listening to notification");
    NotificationService.onClickNotification.stream.listen((event) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationScreen(payload: event)));
    });
  }

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color scaffoldBackgrounfColor =
        context.read<ThemeBloc>().state is SystemTheme
            ? Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white
            : context.read<ThemeBloc>().state is LightTheme
                ? Colors.white
                : Colors.black;

    Color sliverAppBarLargeBgColor =
        context.read<ThemeBloc>().state is SystemTheme
            ? Theme.of(context).brightness == Brightness.light
                ? const Color.fromARGB(255, 187, 187, 187)
                : const Color.fromARGB(255, 61, 61, 61)
            : context.read<ThemeBloc>().state is LightTheme
                ? const Color.fromARGB(255, 187, 187, 187)
                : const Color.fromARGB(255, 61, 61, 61);

    Color sliverAppBarFlexibleSpaceBgColor =
        context.read<ThemeBloc>().state is SystemTheme
            ? Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black
            : context.read<ThemeBloc>().state is LightTheme
                ? Colors.white
                : Colors.black;

    Widget themeIcon = context.read<ThemeBloc>().state is SystemTheme
        ? Theme.of(context).brightness == Brightness.light
            ? Transform.rotate(
                angle: -0.5, child: const Icon(Icons.nightlight_round_sharp))
            : const Icon(Icons.sunny)
        : context.read<ThemeBloc>().state is LightTheme
            ? Transform.rotate(
                angle: -0.5, child: const Icon(Icons.nightlight_round_sharp))
            : const Icon(Icons.sunny);

    return WillPopScope(
      onWillPop: () async {
        if (isSelected) {
          changeSelectedState();
          clearSelectedList();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: scaffoldBackgrounfColor,
          body: CustomScrollView(
            slivers: [
              isSelected
                  ? deletionSliverApppBar(scaffoldBackgrounfColor, context)
                  : mainSliverAppBarLarge(sliverAppBarLargeBgColor, context,
                      sliverAppBarFlexibleSpaceBgColor, themeIcon),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'List of Remiinders',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // reminder cards
              ReminderContainer(
                isSelected: isSelected,
                changeSelectedState: changeSelectedState,
                selectedItemsIDs: selectedItemsIDs,
              ),
            ],
          ),
          floatingActionButton: customFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Container customFloatingActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
      child: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Create A Reminder"),
        onPressed: () async {
          HapticFeedback.lightImpact();

          await showModalBottomSheet(
            showDragHandle: true,
            useSafeArea: true,
            context: context,
            builder: (context) => const CustomBottomSheet(),
          );
        },
      ),
    );
  }

  SliverAppBar mainSliverAppBarLarge(
      Color sliverAppBarLargeBgColor,
      BuildContext context,
      Color sliverAppBarFlexibleSpaceBgColor,
      Widget themeIcon) {
    return SliverAppBar.large(
      pinned: true,
      backgroundColor: sliverAppBarLargeBgColor,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.6,
        titlePadding: const EdgeInsets.only(left: 12, bottom: 16),
        title: Text(
          'Reminde Me',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        background: Container(color: sliverAppBarFlexibleSpaceBgColor),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // context.read<ThemeProvider>().toggleTheme();
              Brightness b = Theme.of(context).brightness;
              if (b == Brightness.dark) {
                context
                    .read<ThemeBloc>()
                    .add(ThemeChangeEvent(changeToTheme: ThemeMode.light));
              } else {
                context
                    .read<ThemeBloc>()
                    .add(ThemeChangeEvent(changeToTheme: ThemeMode.dark));
              }
            },
            icon: themeIcon,
          ),
        ),
      ],
    );
  }

  SliverAppBar deletionSliverApppBar(
      Color scaffoldBackgrounfColor, BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: const Text(''),
      leading: const BackButton(),
      backgroundColor: scaffoldBackgrounfColor,
      actions: [
        isSelected
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.redAccent[100]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.red[900]),
                            ),
                            onPressed: () {
                              int res = 0;
                              try {
                                selectedItemsIDs.forEach((id) async {
                                  res = await NotificationService()
                                      .clearNotification(id);
                                  if (res == 1) {
                                    if (context.mounted) {
                                      context.read<Reminders>().clearAt(id);
                                    }
                                  } else {
                                    debugPrint('couldnt delete reminder');
                                  }
                                });
                                clearSelectedList();
                                changeSelectedState();
                                Navigator.of(context).pop();
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.greenAccent[100]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.green[900]),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          )
                        ],
                        content: const Text(
                            'Are you sure, you want to Delete Selected reminders'),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
