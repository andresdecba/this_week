import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todoapp/core/routes/routes.dart';
import 'package:todoapp/ui/commons/styles.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';


class SideBar extends StatefulWidget {

  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final InitialPageController _controller = Get.put(InitialPageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //padding: const EdgeInsets.all(16),
            children: [
              SvgPicture.asset(
                'assets/weekly-logo.svg',
                alignment: Alignment.center,
                color: Colors.blueAccent,
                width: 100,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text('Navegación'),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Ir a semana Actual'),
                onTap: () {
                  Navigator.of(context).setState(() {
                    _controller.addWeeks = 0;
                    _controller.buildInfo();
                  });
                  //setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outlined),
                title: const Text('Agregar tarea nueva'),
                onTap: () {
                  //Navigator.of(context).pop();
                  _controller.navigate(date: DateTime.now());
                },
              ),
              const Divider(),
              const Text('Configuración'),
              ListTile(
                leading: const Icon(Icons.notifications_off_rounded),
                title: const Text('Silenciar notificaciones'),
                onTap: () {
                  // TODO: implementar
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt_rounded),
                title: const Text('Reset App'),
                subtitle: const Text(
                  'Borrará todas las tareas',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: subTitleTextColor),
                ),
                onTap: () {
                  // TODO: implementar
                },
              ),
              const Divider(),

              
            ],
          ),
        ),
      ),
    );
  }
}


/*

  header:
 // UserAccountsDrawerHeader(
            //   accountName: Text('Oflutter.com'),
            //   accountEmail: Text('example@gmail.com'),
            //   currentAccountPicture: CircleAvatar(
            //     child: ClipOval(
            //       child: Image.network(
            //         'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
            //         fit: BoxFit.cover,
            //         width: 90,
            //         height: 90,
            //       ),
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     image: DecorationImage(
            //         fit: BoxFit.fill,
            //         image: NetworkImage(
            //             'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            //   ),
            // ),


add an extra ‘notification’ to the Request
tuto: https://oflutter.com/create-a-sidebar-menu-in-flutter/
ListTile(
  leading: Icon(Icons.notifications),
  title: Text('Request'),
  onTap: () => null,
  trailing: ClipOval(
    child: Container(
      color: Colors.red,
      width: 20,
      height: 20,
      child: Center(
        child: Text(
          '8',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    ),
  ),
),

*/