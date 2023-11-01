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
      color: widget.isSelected ? const Color.fromARGB(255, 255, 82, 82) : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.keys.first,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '${widget.data.values.first.keys.first}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'At ${widget.data.values.first.values.first}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
