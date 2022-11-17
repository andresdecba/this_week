import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/widgets/task_card_widget.dart';



class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  
  var controller = Get.put(InitialPageController());

  @override
  void initState() {
    setState(() {
      if (controller.getTasks.isNotEmpty) {
        controller.updateTasksList();      
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigate(),
      ),
      body: !controller.hasData.value //controller.dataList.isEmpty
          // no hay
          ? const Center(child: Text('NO HAY NI BOSTA'))
          // crear widgets
          : ValueListenableBuilder<Box<List>>(
              valueListenable: controller.dataListBox.listenable(),
              builder: (context, value, child) {
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
                  // header: Text(
                  //   key: UniqueKey(),
                  //   '--------  ${value.get('listaDatos')!.first}  --------',
                  // ),

                  children: <Widget>[
                    ...value.get('listaDatos')!.map((e) {
                      List list = value.get('listaDatos')!;
                      int idx = list.indexOf(e);

                      // // hide first day
                      // if (e == list.first) {
                      //   return Visibility(
                      //     key: UniqueKey(),
                      //     visible: false,
                      //     child: Text(
                      //       '--------  $e  --------',
                      //     ),
                      //   );
                      // }
                      // // hide last day
                      // if (e == list.last) {
                      //   return Visibility(
                      //     key: UniqueKey(),
                      //     visible: false,
                      //     child: Text(
                      //       '--------  $e  --------',
                      //     ),
                      //   );
                      // }
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

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  
  var controller = Get.put(InitialPageController());

  @override
  void initState() {
    setState(() {
      //controller.updateDataList();
      //print(controller.dataListBox.get('listaDatos'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigate(),
      ),
      body: controller.dataList.isEmpty //controller.listaDeDatos.isEmpty
          // no hay
          ? const Center(child: Text('NO HAY NI BOSTA'))
          // crear widgets
          : ValueListenableBuilder<Box<List>>(
              valueListenable: controller.dataListBox.listenable(),
              builder: (context, value, child) {
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
                    ...value.get('listaDatos')!.map((e) {
                      List listaa = controller.dataList;
                      int idx = listaa.indexOf(e);

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
