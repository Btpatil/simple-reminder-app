import 'package:flutter/material.dart';

class ReminderCard extends StatefulWidget {
  final int idOfRem;
  final Map data;
  final bool isSelected;
  const ReminderCard(
      {super.key,
      required this.idOfRem,
      required this.data,
      required this.isSelected});

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.error, width: 0),
      ),
      color: widget.isSelected ? Theme.of(context).colorScheme.onPrimary : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              '${widget.data.values.first.keys.first}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'At ${widget.data.values.first.values.first}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Divider(),
            Text(
              widget.data.keys.first,
            )
          ],
        ),
      ),
    );
  }
}
