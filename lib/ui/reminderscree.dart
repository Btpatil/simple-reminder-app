import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_application_1/blocs/theme_bloc/theme_state.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatelessWidget {
  final int id;
  const ReminderScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Map data = context.read<Reminders>().data;
    Map notidata = data[id];

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

    return notidata.isEmpty
        ? Container()
        : SafeArea(
            child: Scaffold(
              backgroundColor: scaffoldBackgrounfColor,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    pinned: true,
                    backgroundColor: sliverAppBarLargeBgColor,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1.6,
                      centerTitle: true,
                      // titlePadding: const EdgeInsets.only(left: 12, bottom: 16),
                      title: Text(
                        'Daily Reminder',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      background:
                          Container(color: sliverAppBarFlexibleSpaceBgColor),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${notidata.values.first['Task']}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'At ${notidata.values.first['Time']}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // const Divider(),
                          SizedBox(
                            height: 25,
                            child: Marquee(
                              text:
                                  'Created on : ${notidata.values.first['createdOn'].toString()}',
                              style: Theme.of(context).textTheme.titleSmall,
                              scrollAxis: Axis.horizontal, //scroll direction
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 50.0, //speed
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration:
                                  const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
