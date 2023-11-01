import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';

class TaskAndTimePicker extends StatefulWidget {
  const TaskAndTimePicker({
    super.key,
    required this.tasks,
    required this.addTask,
  });
  final List<Map> tasks;
  final Function addTask;

  @override
  State<TaskAndTimePicker> createState() => _TaskAndTimePickerState();
}

class _TaskAndTimePickerState extends State<TaskAndTimePicker> {
  String selectedTask = tasksForDay.first;
  TimeOfDay sselectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add A Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Task : '),
              SizedBox(
                width: 10,
              ),
              DropdownMenu<String>(
                initialSelection: tasksForDay.first,
                onSelected: (value) {
                  setState(() {
                    selectedTask = value!;
                  });
                },
                dropdownMenuEntries: tasksForDay
                    .map<DropdownMenuEntry<String>>(
                        (String e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Time : '),
              SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: sselectedTime,
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      sselectedTime = timeOfDay;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.watch),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${sselectedTime.hour} ${sselectedTime.minute}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // MaterialButton(
          //   onPressed: ,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: const BorderRadius.all(
          //       Radius.circular(25),
          //     ),
          //     side: BorderSide(
          //       color: Theme.of(context).colorScheme.tertiary,
          //     ),
          //   ),
          //   height: 30,
          //   minWidth: double.infinity,
          //   color: Theme.of(context).colorScheme.tertiary,
          //   child: Text(
          //     'Choose Time',
          //     style: TextStyle(
          //       color: Theme.of(context).colorScheme.onTertiary,
          //     ),
          //   ),
          // ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.error)),
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Map newEntry = {selectedTask: sselectedTime};
            widget.addTask(newEntry);
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.primary)),
          child: Text(
            'Ok',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }
}
