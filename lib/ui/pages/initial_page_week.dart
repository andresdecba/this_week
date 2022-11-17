import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_week_controller.dart';
import 'package:todoapp/ui/widgets/task_card_widget.dart';

class InitialPageWeek extends StatefulWidget {
  const InitialPageWeek({Key? key}) : super(key: key);
  @override
  State<InitialPageWeek> createState() => _InitialPageWeekState();
}

class _InitialPageWeekState extends State<InitialPageWeek> {
  var controller = Get.put(InitialPageWeekController());

  @override
  void initState() {
    setState(() {
      controller.generateWeekDaysList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.generateWeekDaysList();
            controller.moveToWeek = 1;
          },
          icon: const Icon(Icons.today),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.generateWeekDaysList(addWeeks: controller.moveToWeek--),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () => controller.generateWeekDaysList(addWeeks: controller.moveToWeek++),
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigate(),
      ),
      body:
          //!controller.hasData.value //controller.dataList.isEmpty
          // no hay
          //? const Center(child: Text('NO HAY NI BOSTA')) :
          // crear widgets
          Obx(
        () {
          return ReorderableListView(
            padding: const EdgeInsets.all(50),
            buildDefaultDragHandles: true,
            shrinkWrap: true,
            //onReorderEnd: (index) { },
            // onReorderStart: (index) { },
            // proxyDecorator: (child, index, animation) { },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex -= 1;
              setState(() {
                controller.reorderWhenDragAndDrop(oldIndex, newIndex);
              });
            },
            children: <Widget>[
              ...controller.dataList.map((e) {
                List list = controller.dataList;
                int idx = list.indexOf(e);

                if (e is String) {
                  return Text(
                    key: UniqueKey(),
                    '--------  $e  --------',
                  );
                }
                if (e is Task) {
                  return TaskCard(
                    key: UniqueKey(),
                    tarea: e,
                    index: idx,
                  );
                }

                return Container(
                  key: UniqueKey(),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_week_controller.dart';
import 'package:todoapp/ui/widgets/task_card_widget.dart';

class InitialPageWeek extends StatefulWidget {
  const InitialPageWeek({Key? key}) : super(key: key);
  @override
  State<InitialPageWeek> createState() => _InitialPageWeekState();
}

class _InitialPageWeekState extends State<InitialPageWeek> {
  var controller = Get.put(InitialPageWeekController());

  @override
  void initState() {
    setState(() {
      controller.generateWeekDaysList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.generateWeekDaysList();
            controller.moveToWeek = 1;
          },
          icon: const Icon(Icons.today),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.generateWeekDaysList(addWeeks: controller.moveToWeek--),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () => controller.generateWeekDaysList(addWeeks: controller.moveToWeek++),
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigate(),
      ),
      body:
          //!controller.hasData.value //controller.dataList.isEmpty
          // no hay
          //? const Center(child: Text('NO HAY NI BOSTA')) :
          // crear widgets
          Obx(
        () {
          return ReorderableListView(
            padding: const EdgeInsets.all(50),
            buildDefaultDragHandles: true,
            shrinkWrap: true,
            //onReorderEnd: (index) { },
            // onReorderStart: (index) { },
            // proxyDecorator: (child, index, animation) { },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex -= 1;
              setState(() {
                controller.reorderWhenDragAndDrop(oldIndex, newIndex);
              });
            },
            children: <Widget>[
              ...controller.dataList.map((e) {
                List list = controller.dataList;
                int idx = list.indexOf(e);

                if (e is String) {
                  return Text(
                    key: UniqueKey(),
                    '--------  $e  --------',
                  );
                }
                if (e is Task) {
                  return TaskCard(
                    key: UniqueKey(),
                    tarea: e,
                    index: idx,
                  );
                }

                return Container(
                  key: UniqueKey(),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

*/