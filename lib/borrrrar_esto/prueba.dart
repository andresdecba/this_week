// /*
// {
//   [
//     {
//     "2023-01-01 00:00:00.000": [
//         {
//             "Enero": [
//                 {
//                     "semana 1":
//                         [
//                             {
//                               "2023/05/31" :
//                               [
//                                 {"tasks" : ["tarea_1"]}
//                               ]
//                             },
//                              {
//                               "2023/06/01" :
//                               [
//                                 {"tasks" : ["tarea"]}
//                               ]
//                             },
//                         ]
//                 }
//              ],
//         }
//     ]
//   },
//   {
//     "2023-01-01 00:00:00.000": [{task}, {task}],
//     "2023-01-02 00:00:00.000": [],
//     "2023-01-03 00:00:00.000": [{task}],
//     "2023-01-04 00:00:00.000": [{task}, {task}],
//   }
//   ]
// }
// */

// /*

// {
//   "taskBox": [
//     "1": {date: 21/05/2023, ...},
//     "2": {date: 03/06/2023, ...}
//   ]
// }



// */

// import 'package:flutter/material.dart';
// import 'package:intl/date_time_patterns.dart';
// import 'package:todoapp/models/task_model.dart';

// class Nuevo {
//   final Map< String, List<Map<String, TaskModel>> > fecha;
//   Nuevo({
//     required this.fecha,
//   });
// }

// class MyCalendar {
//   final List<Year> years;

//   MyCalendar({
//     required this.years,
//   });
// }

// class Year {
//   final List<Month> months;

//   Year({
//     required this.months,
//   });
// }

// class Month {
//   final List<Week> weeks;

//   Month({
//     required this.weeks,
//   });
// }

// class Week {
//   final List<Day> days;

//   Week({
//     required this.days,
//   });
// }

// class Day {
//   final List<TaskModel> tasks;
//   final DateTime date;

//   Day({
//     required this.tasks,
//     required this.date,
//   });
// }

// class CreateCalendar {
//   final calendar = MyCalendar(
//     years: [
//       Year(
//         months: [
//           Month(
//             weeks: [
//               Week(
//                 days: [
//                   Day(
//                     date: DateTime(2023, 5, 31),
//                     tasks: [],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Month(
//             weeks: [
//               Week(
//                 days: [
//                   Day(
//                     date: DateTime(2023, 5, 31),
//                     tasks: [],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );

//   void algo() {
//     //
//     calendar.years;
//     calendar.years[0].months[5].weeks[3].days[30].tasks.add(
//       TaskModel(
//         description: 'description',
//         taskDate: DateTime.now(),
//         status: 'status',
//         subTasks: [],
//       ),
//     );

//     for (var e in calendar.years[0].months[3].weeks) {
//       e.days;
//     }
//   }

//   var task_model = TaskModel(
//         description: 'description',
//         taskDate: DateTime.now(),
//         status: 'status',
//         subTasks: [],
//       );


//   void algoMas() {

//     var nuevo = Nuevo(fecha:{ "2023/05/31 00:00:00.000": [ {"key": task_model}, {"key": task_model}, ]});
    

//     nuevo.fecha.entries[1]
//   }
// }
