import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  final String? payload;
  const NotificationScreen({super.key, this.payload});

  @override
  Widget build(BuildContext context) {
    Map data = context.read<Reminders>().data;
    Map notidata = data[int.parse(payload!)];

    return notidata.isEmpty
        ? Container()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: const BackButton(),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Text(
                      '${notidata.values.first['Task']}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'At ${notidata.values.first['Time']}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    SizedBox(
                      height: 25,
                      child: Marquee(
                        text:
                            'Created on : ${notidata.values.first['createdOn'].toString()}',
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
            ),
          );
  }
}
