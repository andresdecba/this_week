import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:todoapp/core/globals.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/initial_page/build_page_controller.dart';
import 'package:todoapp/ui/initial_page/components/build_tasks.dart';
import 'package:todoapp/ui/initial_page/components/header.dart';

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

class _BuildPageState extends State<BuildPage> {
  final _controller = Get.find<BuildPageController>();
  RxList<Rx<TaskModel>> _tasks = RxList<Rx<TaskModel>>([]);

  @override
  void initState() {
    super.initState();
    // construyo la lista de tareas segun la semana provista //
    _tasks = _controller.buildTasks(tasksBox: _controller.tasksBox, week: widget.week);
    // exponer globalmente //
    Globals.tasksGlobal = _tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER //
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          alignment: Alignment.topLeft,
          width: double.infinity,
          color: _setBgColors(),
          child: SafeArea(
            child: Column(
              children: [
                // header
                Header(
                  week: widget.week,
                  textColor: blackBg,
                ),
              ],
            ),
          ),
        ),

        // TASKS //
        Expanded(
          child: Stack(
            children: [
              // destras de las tareas
              Container(
                color: _setBgColors(),
                width: double.infinity,
                height: 100,
              ),

              // tasks
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  children: [
                    // tasks
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: BuildTasks(
                        week: widget.week,
                        tasks: _tasks,
                      ),
                    ),

                    // Gradientes blanco a transparente
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.white.withOpacity(0.1)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _setBgColors() {
    var value1 = widget.week.weekNumber;
    var value2 = Week.current().weekNumber;
    // pasado
    if (value1 < value2) {
      return Colors.brown.withOpacity(0.6);
    }
    // futuro
    if (value1 > value2) {
      return Colors.teal.withOpacity(0.6);
    }
    // presente
    return yellowPrimary.withOpacity(0.75);
  }
}
