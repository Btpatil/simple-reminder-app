import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/service/notifyservice.dart';
import 'package:flutter_application_1/widgets/showsnackbar.dart';
import 'package:flutter_application_1/widgets/task_time_dialogbox.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  NotificationService notificationService = NotificationService();
  String selectedDay = dayOfWeek.first;
  List<Map<String, List<Map>>> task = [];

  refreshTask() {
    task = [
      {selectedDay: []}
    ];
    setState(() {});
  }

  addTask(Map newTask) {
    // tasks.addEntries(task.entries);
    // tasks.map(
    //   (key, value) {
    //     tasks = tasks[key] = task;
    //     print('$tasks');
    //     return tasks;
    //   },
    // );
    // print(task);
    task[0][selectedDay]?.add(newTask);
    // print(task);
    // task.map((e) {
    //   e[selectedDay]?.add(newTask);
    // });
    // task = task[selectedDay]?.add(newTask);
    // print('$tasks');
    setState(() {});
  }

  closeBottomSheet() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    notificationService.initalizeNotification();
    task = [
      {selectedDay: []}
    ];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // backgroundColor: csche,
      body: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Choose A Day : ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                DropdownMenu<String>(
                  initialSelection: dayOfWeek.first,
                  onSelected: (value) {
                    selectedDay = value!;
                    refreshTask();
                  },
                  dropdownMenuEntries: dayOfWeek
                      .map<DropdownMenuEntry<String>>(
                          (String e) => DropdownMenuEntry(value: e, label: e))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TaskAndTimePicker(
                      tasks: task,
                      addTask: addTask,
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(
                  color: colorScheme.tertiary,
                ),
              ),
              height: 50,
              color: colorScheme.tertiary,
              splashColor: colorScheme.primary,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: colorScheme.onTertiary,
                  ),
                  Text(
                    'Choose a task and time',
                    style: TextStyle(
                      color: colorScheme.onTertiary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemCount: task[0].values.first.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                print(task[0].values.first[index].keys.first);
                return Chip(
                    label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      task[0].keys.first,
                      maxLines: 1,
                    ),
                    Text(
                      task[0].values.first[index].keys.first,
                      maxLines: 1,
                    ),
                    Text(
                      task[0].values.first[index].values.first.toString(),
                      maxLines: 1,
                    ),
                  ],
                ));
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  closeBottomSheet();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  side: BorderSide(
                    color: colorScheme.error,
                  ),
                ),
                height: 50,
                color: colorScheme.error,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: colorScheme.onError,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  task[0].forEach(
                    (key, value) {
                      int day = dayOfWeek.indexOf(key);
                      if (value.isNotEmpty) {
                        value.forEach(
                          (element) async {
                            var hour = element.values.first.hour > 12
                                ? 24 - element.values.first.hour
                                : element.values.first.hour == 0
                                    ? 12
                                    : element.values.first.hour;
                            hour = hour < 12 ? '0$hour' : '$hour';
                            var minutes = element.values.first.minute < 10
                                ? '0${element.values.first.minute}'
                                : '${element.values.first.minute}';
                            var AMPM = element.values.first.hour > 12
                                ? 'PM'
                                : element.values.first.hour == 0
                                    ? 'AM'
                                    : 'AM';
                            Map ele = {
                              'createdOn': DateTime.now(),
                              'Task': element.keys.first,
                              'Time': '$hour:$minutes $AMPM'
                            };

                            // print('$hour:$minutes $AMPM');
                            // add to db
                            int id = await context
                                .read<Reminders>()
                                .addToReminders({key: ele});

                            if (id != -1) {
                              // notify
                              String res = await notificationService
                                  .scheduleNotification(
                                id,
                                '${element.keys.first}',
                                'it\'s ${element.values.first.hour} : ${element.values.first.minute}',
                                element.values.first.hour,
                                element.values.first.minute,
                                day,
                              );

                              if (res == 'success') {
                                closeBottomSheet();
                                if (context.mounted) {
                                  showSnackbar(
                                    'Reminder is Set!!',
                                    context,
                                    false,
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  showSnackbar(
                                    'Something Went Wrong',
                                    context,
                                    true,
                                  );
                                  context.read<Reminders>().clearAt(id);
                                }
                              }
                            }
                          },
                        );
                      } else {
                        showSnackbar(
                          'Please add some reminders first!!',
                          context,
                          false,
                        );
                      }
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                    side: BorderSide(
                      color: colorScheme.primary,
                    )),
                height: 50,
                color: colorScheme.primary,
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
