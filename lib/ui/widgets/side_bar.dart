import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/ui/controllers/initial_page_controller.dart';

class SideBar extends GetView<InitialPageController> {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('LOGO', textAlign: TextAlign.right),
            const Divider(),
            const Text('Navegación'),
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Ir a semana Actual'),
              onTap: () {
                Navigator.of(context).pop();
                controller.buildInfo();
                controller.addWeeks = 0;
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outlined),
              title: const Text('Agregar tarea nueva'),
              onTap: () {
                //Navigator.of(context).pop();
                controller.navigate();
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
            const Divider(),
          ],
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