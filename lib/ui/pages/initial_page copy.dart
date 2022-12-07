import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedListSample());
}

class AnimatedListSample extends StatefulWidget {
  const AnimatedListSample({super.key});

  @override
  State<AnimatedListSample> createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<int> _list;
  int? _selectedItem;
  late int _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index = _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, _nextItem++);
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              tooltip: 'remove the selected item',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(T item, BuildContext context, Animation<double> animation);

/// Keeps a Dart [List] in sync with an [AnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value.
///
/// The text is displayed in bright green if [selected] is
/// true. This widget's height is based on the [animation] parameter, it
/// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    this.selected = false,
    required this.animation,
    required this.item,
  }) : assert(item >= 0);

  final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4!;
    if (selected) {
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text('Item $item', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:todoapp/models/task_model.dart';
// import 'package:todoapp/ui/controllers/initial_page_controller.dart';
// import 'package:todoapp/ui/widgets/task_card_widget.dart';
// import 'package:intl/intl.dart';

// class InitialPage extends StatefulWidget {
//   const InitialPage({Key? key}) : super(key: key);
//   @override
//   State<InitialPage> createState() => _InitialPageState();
// }

// class _InitialPageState extends State<InitialPage> {
//   final InitialPageController _controller = Get.put(InitialPageController());

//   @override
//   void initState() {
//     setState(() {
//       _controller.generateWeekDaysList();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             _controller.generateWeekDaysList();
//             _controller.moveToWeek = 1;
//           },
//           icon: const Icon(Icons.today),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () => _controller.generateWeekDaysList(addWeeks: _controller.moveToWeek--),
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//           IconButton(
//             onPressed: () => _controller.generateWeekDaysList(addWeeks: _controller.moveToWeek++),
//             icon: const Icon(Icons.arrow_forward_ios),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _controller.navigate(),
//       ),
//       body:
//           //!controller.hasData.value //controller.dataList.isEmpty
//           // no hay
//           //? const Center(child: Text('NO HAY NI BOSTA')) :
//           // crear widgets
//           Obx(
//         () {
//           //return reorde
//           return ReorderableListView(
//             padding: const EdgeInsets.all(20),
//             buildDefaultDragHandles: true,
//             shrinkWrap: true,
//             // proxyDecorator: (child, index, animation) {
//             //   return child; ///////////// aca se puede poner un efecto para cuando esta flotante
//             // },
//             // onReorderEnd: (index) { },
//             // onReorderStart: (index) { },
//             // proxyDecorator: (child, index, animation) { },
//             onReorder: (int oldIndex, int newIndex) {
//               if (oldIndex < newIndex) newIndex -= 1;
//               setState(() {
//                 _controller.reorderWhenDragAndDrop(oldIndex, newIndex);
//               });
//             },
//             children: <Widget>[
//               ..._controller.dataList.map((e) {
//                 List list = _controller.dataList;
//                 int idx = list.indexOf(e);

//                 // hide last day
//                 if (e == list.last) {
//                   return SizedBox(
//                     key: UniqueKey(),
//                   );
//                 }
//                 // show dates
//                 if (e is DateTime) {
//                   return Padding(
//                     key: UniqueKey(),
//                     padding: const EdgeInsets.fromLTRB(0, 30, 0, 8),
//                     // child: Text(
//                     //   DateFormat('EEEE MM-dd').format(e),
//                     //   style: const TextStyle(fontSize: 18),
//                     // ),
//                     child: RichText(
//                       text: TextSpan(
//                         text: DateFormat('EEEE').format(e),
//                         style: const TextStyle(fontSize: 18, color: Colors.black),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: '   ${DateFormat('MM-dd-yy').format(e)}',
//                             style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//                 // show no tasks
//                 if (e is String) {
//                   return Container(
//                     key: UniqueKey(),
//                     height: 50,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.4),
//                       borderRadius: const BorderRadius.all(Radius.circular(5)),
//                     ),
//                     alignment: Alignment.centerLeft,
//                     padding: const EdgeInsets.all(16),
//                     child: const Text(
//                       'No hay tareas',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }
//                 // show tasks
//                 if (e is Task) {
//                   return TaskCardWidget(
//                     key: UniqueKey(),
//                     tarea: e,
//                     index: idx,
//                   );
//                 }
//                 // return default
//                 return Container(
//                   key: UniqueKey(),
//                 );
//               }),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
