import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:max_task/Home/home_controller.dart';

import '../consts/colorconstants.dart';
import '../consts/textstyles.dart';


class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  var homeController = Get.put(HomeController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var dueDate;
  final TextEditingController dueDateController = TextEditingController();
  var status = ["Completed", "Non Completed"];
  var filters = ["Completed", "Non Completed", "All"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add task',style: TextingStyle.font14BoldWhite,),
          backgroundColor: ColorConstant.darkblue,
          onPressed: () {
            titleController.text = "";
            descriptionController.text = "";
            dueDateController.text = "";
            homeController.selectedStatus.value = "";
            showbottomSheet(context, null);
          },
        
          ),
      appBar: AppBar(
        title: Text("My Tasks"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: SizedBox(
                  height: 50,
                  child: DropdownButtonFormField<String>(
                      value: homeController.selectedFilter.value == ""
                          ? null
                          : homeController.selectedFilter.value,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Search by status",
                          hintStyle: TextingStyle.font14NormalGreyy,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: ColorConstant.darkblue)),
                          //border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstant.darkblue),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          border: OutlineInputBorder()),
                      items: filters.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        homeController.selectedFilter.value =
                            newValue.toString();
                        if (homeController.selectedFilter.value ==
                            "Completed") {
                          homeController.filteredItems =
                              homeController.getCompletedTasks();
                          homeController.refreshItem();
                        } else if (homeController.selectedFilter.value ==
                            "Non Completed") {
                          homeController.filteredItems =
                              homeController.getNonCompletedTasks();

                          homeController.refreshItem();
                        }
                        // else if (homeController.selectedFilter.value == "All") {
                        //   print(homeController.filteredItems);
                        //   homeController.filteredItems = homeController.items;
                        //   homeController.refreshItem();
                        // }
                        else if (homeController.selectedFilter.value == "All") {
                          homeController.filteredItems = homeController.items;
                          homeController.refreshItem();
                        } else {
                          homeController.filteredItems = homeController.items;
                        }
                        print(homeController.selectedFilter.value);
                      }),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton.icon(
              //         onPressed: () {},
              //         icon: Icon(Icons.add),
              //         label: Text("Add Task"))
              //   ],
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              GetBuilder<HomeController>(
                builder: (controller) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.filteredItems.length,
                    itemBuilder: (context, index) {
                      final currentItem = controller.filteredItems[index];
                      return 
                      controller.filteredItems.isEmpty ?
                      const Center(child: Text('Please add task'),):
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorConstant.containcolo,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              currentItem["title"],
                                              style:
                                                  TextingStyle.font16boldWhite,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showbottomSheet(context,
                                                    currentItem["key"]);
                                              },
                                              child: Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    color:
                                                        ColorConstant.darkblue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Edit',
                                                      style: TextingStyle
                                                          .font12NormalWhite,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Delete Task'),
                                                      content: const Text(
                                                        'Are you sure want to delete this task?',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      actions: <Widget>[
                                                        // Add buttons to the AlertDialog
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the AlertDialog
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            controller
                                                                .deleteTask(
                                                                    currentItem[
                                                                        "key"],
                                                                    context);
                                                            controller
                                                                .refreshItem();
                                                            if (controller
                                                                    .selectedFilter
                                                                    .value ==
                                                                "Completed") {
                                                              controller
                                                                      .filteredItems =
                                                                  controller
                                                                      .getCompletedTasks();
                                                              controller
                                                                  .refreshItem();
                                                            } else if (controller
                                                                    .selectedFilter
                                                                    .value ==
                                                                "Non Completed") {
                                                    
                                                              controller
                                                                      .filteredItems =
                                                                  controller
                                                                      .getNonCompletedTasks();
                                                            } else if (controller
                                                                    .selectedFilter
                                                                    .value ==
                                                                "All") {
                                                              controller
                                                                      .filteredItems =
                                                                  controller
                                                                      .items;
                                                              controller
                                                                  .refreshItem();
                                                            } else if (controller
                                                                    .selectedFilter
                                                                    .value ==
                                                                "") {
                                                              controller
                                                                      .filteredItems =
                                                                  controller
                                                                      .items;
                                                              controller
                                                                  .refreshItem();
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('Yes'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    color: ColorConstant.Red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Center(
                                                      child: Text(
                                                    'Delete',
                                                    style: TextingStyle
                                                        .font12NormalWhite,
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                currentItem["description"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                                style: TextingStyle
                                                    .font14NormalWhite,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorConstant.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 2,
                                                bottom: 2),
                                            child: Text(
                                              currentItem["status"],
                                              style:
                                                  TextingStyle.font16BoldBlack,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: -1,
                              child: Container(
                                height: 25,
                                width: 120,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: ColorConstant.darkblue,
                                ),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentItem["due date"],
                                      style: TextingStyle.font12NormalWhite,
                                    ),
                                  ],
                                )),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  showbottomSheet(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem = homeController.items
          .firstWhere((element) => element["key"] == itemKey);
      titleController.text = existingItem["title"];
      descriptionController.text = existingItem["description"];
      dueDateController.text = existingItem["due date"];
      homeController.selectedStatus.value = existingItem["status"];
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 15,
              right: 15,
              top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFormField(
                controller: dueDateController,
                decoration: const InputDecoration(hintText: "Due Date"),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownButtonFormField<String>(
                  value: homeController.selectedStatus.value == ""
                      ? null
                      : homeController.selectedStatus.value,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Select status",
                      border: UnderlineInputBorder()),
                  items: status.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    homeController.selectedStatus.value = newValue.toString();
                
                    // catController.fetchSubCategory(catId);
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(ColorConstant.darkblue)),
                  onPressed: () async {
                    if (itemKey == null) {
                      homeController.createTask({
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "due date": dueDateController.text,
                        "status": homeController.selectedStatus.value
                      });
                      homeController.refreshItem();
                    }

                    if (itemKey != null) {
                      homeController.updateTask(itemKey, {
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "due date": dueDateController.text,
                        "status": homeController.selectedStatus.value
                      });

                      homeController.refreshItem();
                    }

                    if (homeController.selectedFilter.value == "Completed") {
                      homeController.filteredItems =
                          homeController.getCompletedTasks();
                      homeController.refreshItem();
                    } else if (homeController.selectedFilter.value ==
                        "Non Completed") {
                
                      homeController.filteredItems =
                          homeController.getNonCompletedTasks();
                    } else if (homeController.selectedFilter.value == "All") {
                      homeController.filteredItems = homeController.items;
                      homeController.refreshItem();
                    } else if (homeController.selectedFilter.value == "") {
                      homeController.filteredItems = homeController.items;
                      homeController.refreshItem();
                    }
                    homeController.refreshItem();
                    titleController.text = '';
                    descriptionController.text = '';
                    dueDateController.text = '';
                    homeController.selectedStatus.value = '';

                    Get.back();
                  },
                  child: itemKey == null
                      ? const Text(
                          "Add new Task",
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          "Edit Task",
                          style: TextStyle(color: Colors.white),
                        )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: homeController.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    homeController.selectedDate.value = picked!;
    dueDate = DateFormat('MMM-dd-yyyy')
        .format(DateTime.parse(homeController.selectedDate.toString()));
    dueDateController.text = dueDate;
  }
}
