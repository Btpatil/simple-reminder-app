import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: widget.isSelected ? Colors.redAccent : null,
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
            // const Divider(),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${widget.data.values.first['Task']}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'At ${widget.data.values.first['Time']}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            // const Divider(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 25,
              child: Marquee(
                text: widget.data.values.first['createdOn'].toString(),
                style: Theme.of(context).textTheme.labelSmall,
                scrollAxis: Axis.horizontal, //scroll direction
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 50.0, //speed
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
