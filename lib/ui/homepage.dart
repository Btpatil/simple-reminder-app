import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/provider/themeprovider.dart';
import 'package:flutter_application_1/service/notifyservice.dart';
import 'package:flutter_application_1/ui/bottomsheet.dart';
import 'package:flutter_application_1/ui/notificationscreen.dart';
import 'package:flutter_application_1/ui/reminder_container.dart';
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

  @override
  void initState() {
    listenToNotifications();
    super.initState();
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
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
          // backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              isSelected
                  ? SliverAppBar(
                      title: const Text(''),
                      leading: const BackButton(),
                      // backgroundColor: colorScheme.inversePrimary,
                      actions: [
                        isSelected
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.redAccent[100]),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red[900]),
                                            ),
                                            onPressed: () {
                                              int res = 0;
                                              try {
                                                selectedItemsIDs
                                                    .forEach((id) async {
                                                  res =
                                                      await NotificationService()
                                                          .clearNotification(
                                                              id);
                                                  if (res == 1) {
                                                    if (context.mounted) {
                                                      context
                                                          .read<Reminders>()
                                                          .clearAt(id);
                                                    }
                                                  } else {
                                                    debugPrint(
                                                        'couldnt delete reminder');
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
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.greenAccent[100]),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green[900]),
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
                    )
                  : SliverAppBar.large(
                      title: const Text('Reminder'),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                context.read<ThemeProvider>().toggleTheme();
                              },
                              icon: context.read<ThemeProvider>().themeMode
                                  ? Transform.rotate(
                                      angle: -0.5,
                                      child: const Icon(
                                          Icons.nightlight_round_sharp))
                                  : const Icon(Icons.sunny)),
                        ),
                      ],
                      // backgroundColor: colorScheme.inversePrimary,
                    ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // !isSelected ?
                      AnimatedOpacity(
                        opacity: isSelected ? 0 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: isSelected ? 0 : 75,
                          curve: Curves.easeIn,
                          child: MaterialButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();

                              await showModalBottomSheet(
                                showDragHandle: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) => const CustomBottomSheet(),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: colorScheme.tertiary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            // height: 75,
                            color: colorScheme.tertiary,
                            child: ListTile(
                              title: Text(
                                'Create Reminders',
                                style: TextStyle(color: colorScheme.onTertiary),
                              ),
                              leading: Icon(
                                Icons.punch_clock,
                                color: colorScheme.onTertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // : Container(),
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
        ),
      ),
    );
  }
}
