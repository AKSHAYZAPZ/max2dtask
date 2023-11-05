import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  List<Map<String, dynamic>> items = [];
  Rx<DateTime> selectedDate = DateTime.now().obs;
  List<Map<String, dynamic>> filteredItems = [];

  var formatedDate = DateFormat('MMM-dd-yyyy')
      .format(DateTime.parse(DateTime.now().toString()))
      .obs;
  var selectedStatus = "".obs;
  var selectedFilter = "".obs;

  final taskBox = Hive.box("task_box");

  void refreshItem() {
    final data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "description": item["description"],
        "due date": item["due date"],
        "status": item["status"]
      };
    }).toList();
    items = data.reversed.toList();
    update();
    print(items.length);
  }

  Future<void> createTask(Map<String, dynamic> newItem) async {
    await taskBox.add(newItem);
    print("dataaaa${taskBox.length}");
    update();
    refreshItem();
  }

  Future<void> updateTask(int itemKey, Map<String, dynamic> item) async {
    await taskBox.put(itemKey, item);

    refreshItem();
  }

  Future<void> deleteTask(int itemKey, context) async {
    await taskBox.delete(itemKey);

    refreshItem();
  }

  List<Map<String, dynamic>> getCompletedTasks() {
    return items.where((item) => item["status"] == "Completed").toList();
  }

  List<Map<String, dynamic>> getNonCompletedTasks() {
    return items.where((item) => item["status"] == "Non Completed").toList();
  }

  @override
  void onInit() {
    refreshItem();
    if (filteredItems.isEmpty) {
      filteredItems = items;
    }
    print(filteredItems);
    print(items);
    super.onInit();
  }
}
