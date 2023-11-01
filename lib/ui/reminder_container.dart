import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/reminders.dart';
import 'package:flutter_application_1/widgets/remindercard.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReminderContainer extends StatefulWidget {
  final bool isSelected;
  final Function changeSelectedState;
  final List selectedItemsIDs;
  const ReminderContainer({
    super.key,
    required this.isSelected,
    required this.changeSelectedState,
    required this.selectedItemsIDs,
  });

  @override
  State<ReminderContainer> createState() => _ReminderContainerState();
}

class _ReminderContainerState extends State<ReminderContainer> {
  addOrRemoveToSelectedItemsIDs(int id) {
    if (widget.selectedItemsIDs.contains(id)) {
      print(true);
      widget.selectedItemsIDs.remove(id);
      setState(() {});
    } else {
      print(false);
      widget.selectedItemsIDs.add(id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverMasonryGrid(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        delegate: SliverChildBuilderDelegate(
          childCount: context.watch<Reminders>().reminders.length,
          (context, index) {
            Map data = context.read<Reminders>().data;
            // data.forEach(
            //   (key, value) {
            //     print('$key ${value.runtimeType}');
            //   },
            // );
            List keys = data.keys.toList();
            List values = data.values.toList();

            return GestureDetector(
              onLongPress: () {
                if (!widget.isSelected) {
                  print('changed isselectedd');
                  widget.changeSelectedState();
                  addOrRemoveToSelectedItemsIDs(keys[index]);
                }
              },
              onTap: () {
                if (widget.isSelected) {
                  print('on tap');
                  addOrRemoveToSelectedItemsIDs(keys[index]);
                }
              },
              child: ReminderCard(
                idOfRem: keys[index],
                data: values[index],
                isSelected: widget.selectedItemsIDs.contains(keys[index]),
              ),
            );
          },
        ),
        // child: MasonryGridView.count(
        //   itemCount: 100,
        //   // itemCount: context.watch<Reminders>().reminders.length,
        //   scrollDirection: Axis.vertical,
        //   crossAxisCount: 2,
        //   mainAxisSpacing: 4,
        //   crossAxisSpacing: 4,
        //   shrinkWrap: true,
        //   itemBuilder: (context, index) => ReminderCard(),
        // ),
      ),
    );
  }
}
