import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';
import 'package:todoapp/ui/widgets/task_card_widget.dart';
import 'package:intl/intl.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final InitialPageController _controller = Get.put(InitialPageController());

  @override
  void initState() {
    setState(() {
      _controller.generateWeekDaysList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _controller.generateWeekDaysList();
            _controller.moveToWeek = 1;
          },
          icon: const Icon(Icons.today),
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.generateWeekDaysList(addWeeks: _controller.moveToWeek--),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: () => _controller.generateWeekDaysList(addWeeks: _controller.moveToWeek++),
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.navigate(),
      ),
      body:
          //!controller.hasData.value //controller.dataList.isEmpty
          // no hay
          //? const Center(child: Text('NO HAY NI BOSTA')) :
          // crear widgets
          Obx(
        () {
          //return reorde
          return ReorderableListView(
            padding: const EdgeInsets.all(20),
            buildDefaultDragHandles: true,
            shrinkWrap: true,
            // proxyDecorator: (child, index, animation) {
            //   return child; ///////////// aca se puede poner un efecto para cuando esta flotante
            // },
            // onReorderEnd: (index) { },
            // onReorderStart: (index) { },
            // proxyDecorator: (child, index, animation) { },
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex -= 1;
              setState(() {
                _controller.reorderWhenDragAndDrop(oldIndex, newIndex);
              });
            },
            children: <Widget>[
              ..._controller.dataList.map((e) {
                List list = _controller.dataList;
                int idx = list.indexOf(e);

                // hide last day
                if (e == list.last) {
                  return SizedBox(
                    key: UniqueKey(),
                  );
                }
                // show dates
                if (e is DateTime) {
                  return Padding(
                    key: UniqueKey(),
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 8),
                    // child: Text(
                    //   DateFormat('EEEE MM-dd').format(e),
                    //   style: const TextStyle(fontSize: 18),
                    // ),
                    child: RichText(
                      text: TextSpan(
                        text: DateFormat('EEEE').format(e),
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '   ${DateFormat('MM-dd-yy').format(e)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // show no tasks
                if (e is String) {
                  return Container(
                    key: UniqueKey(),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'No hay tareas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                // show tasks
                if (e is Task) {
                  return TaskCardWidget(
                    key: UniqueKey(),
                    tarea: e,
                    index: idx,
                  );
                }
                // return default
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
