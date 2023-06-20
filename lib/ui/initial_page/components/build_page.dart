import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/create_task_page/create_task_page.dart';
import 'package:todoapp/ui/create_task_page/create_task_page_controller.dart';
import 'package:todoapp/ui/initial_page/build_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/header.dart';
import 'package:todoapp/ui/initial_page/components/task_card.dart';
import 'package:todoapp/ui/shared_components/create_task_bottomsheet.dart';
import 'package:todoapp/ui/shared_components/view_task_bottomsheet.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page.dart';
import 'package:todoapp/ui/view_task_page.dart/view_task_page_controller.dart';
import 'package:todoapp/utils/helpers.dart';

/*
Tutorial como mantener el estado de la pagina:
https://stackoverflow.com/questions/67662298/flutter-how-to-keep-the-page-alive-when-changing-it-with-pageview-or-bottomnav
*/

class BuildPage extends StatefulWidget {
  const BuildPage({required this.week, Key? key}) : super(key: key);
  final Week week;
  @override
  State<BuildPage> createState() => _BuildPageState();
}

class _BuildPageState extends State<BuildPage> with AutomaticKeepAliveClientMixin {
  final _controller = Get.find<BuildPageController>();
  RxList<Rx<TaskModel>> _tasks = RxList<Rx<TaskModel>>([]);

  //late KeepAliveHandle _keepAliveHandle;

  @override
  void initState() {
    super.initState();
    // construyo la lista de tareas segun la semana provista //
    _tasks = _controller.buildTasks(tasksBox: _controller.tasksBox, week: widget.week);
    // exponer globalmente //
    Globals.tasksGlobal = _tasks;
    print('hashhh: en widget ${Globals.tasksGlobal.hashCode}');

    // keep alive
    //_keepAliveHandle = KeepAliveHandle();
    //updateKeepAlive();

    print('aaaver: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('aaaver: didChangeDependencies');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('aaaver: deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    print('aaaver: dispose');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header
            Header(week: widget.week),
            const Divider(color: disabledGrey, height: 12),
            const SizedBox(height: 6),

            // ElevatedButton(
            //   onPressed: () {
            //     _tasks = _controller.buildTasks(tasksBox: _controller.tasksBox, week: widget.week);
            //     _tasks.refresh();
            //     updateKeepAlive();
            //     print('jajajja');
            //   },
            //   child: Text('update'),
            // ),

            /// iteramos todos los dias de la semana para mostrarlos en una columna ///
            ...widget.week.days.map((e) {
              // si es el dia de hoy
              var today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              bool isToday = e.isAtSameMomentAs(today);

              // deshabilitar los dias anteriores a hoy
              bool disableAddNewTask = (e.isBefore(today)) ? true : false;

              // dias sin tareas
              bool hasTasks = false;
              for (var element in _tasks) {
                if (element.value.date == e) {
                  hasTasks = true;
                }
              }

              // MOSTRAR DIAS //
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // MOSTRAR DIA //
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: weekdayOnlyFormater(e),
                            style: isToday ? kTitleLarge.copyWith(color: bluePrimary) : kTitleLarge,
                            children: <TextSpan>[
                              TextSpan(
                                text: '   ${standardDateFormater(e)}',
                                style: isToday ? kBodySmall.copyWith(color: bluePrimary) : kBodySmall.copyWith(color: disabledGrey),
                              ),
                            ],
                          ),
                        ),
                        disableAddNewTask
                            ? IconButton(
                                icon: const Icon(Icons.add),
                                visualDensity: VisualDensity.compact,
                                disabledColor: whiteBg.withOpacity(0),
                                onPressed: null,
                              )

                            /// CREATE TASK
                            : IconButton(
                                icon: Icon(Icons.add, color: isToday ? bluePrimary : disabledGrey),
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  Get.put(CreateTaskPageController(selectedDate: e));
                                  createTaskBottomSheet(
                                    context: context,
                                    child: CreateTaskPage(tasks: _tasks),
                                    enableDrag: true,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),

                  /// SHOW NO TASKS
                  if (!hasTasks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        key: UniqueKey(),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: isToday ? bluePrimary.withOpacity(0.25) : Colors.grey[200]
                          //borderRadius: const BorderRadius.all(Radius.circular(50)),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          border: Border.all(width: 1, color: Colors.grey[200]!),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'no tasks'.tr,
                          style: kBodyMedium.copyWith(color: Colors.grey[300]),
                        ),
                      ),
                    ),

                  // MOSTRAR TAREAS DE ESTE DIA "e" //
                  ..._tasks.map((task) {
                    if (task.value.date == e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TaskCard(
                          isToday: isToday,
                          key: UniqueKey(),
                          task: task.value,
                          navigate: () {
                            Get.put(ViewTaskController(task: task));
                            viewTaskBottomSheet(
                              context: context,
                              child: ViewTask(tasks: _tasks),
                            );
                          },
                          onStatusChange: () {
                            task.value.status = _controller.changeTaskStatus(task.value.status);
                            task.value.save();
                            _controller.generateStatistics();
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

                  const SizedBox(height: 12),
                ],
              );
            })
          ],
        ),
      );
    });
  }
}
