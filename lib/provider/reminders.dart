import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Reminders with ChangeNotifier {
  final Box _reminderBox = Hive.box('Reminders');

  Box get reminders => _reminderBox;

  get data => getAllRems();

  getAllRems() {
    try {
      Map data = _reminderBox.toMap();
      return data;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<int> addToReminders(Map task) async {
    try {
      int key = await _reminderBox.add(task);

      notifyListeners();
      return key;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future clearAt(int id) async {
    await _reminderBox.delete(id);

    notifyListeners();
  }

  Future clearAll(List ids) async {
    await _reminderBox.deleteAll(ids);

    notifyListeners();
  }

  Future clearAllReminders() async {
    print('${_reminderBox.keys}');
    await _reminderBox.deleteAll(_reminderBox.keys);

    notifyListeners();
  }
}
