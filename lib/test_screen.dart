// import 'package:flutter/material.dart';
// import 'package:flutter_project_ii/api_module/event_logic.dart';
// import 'package:flutter_project_ii/auth/auth.dart';
// import 'package:provider/provider.dart';

// class EventsScreen extends StatefulWidget {
//   @override
//   _EventsScreenState createState() => _EventsScreenState();
// }

// class _EventsScreenState extends State<EventsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch events when the screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final token = context.read<AuthProvider>().token;
//       if (token != null) {
//         context.read<EventLogic>().fetchEvents(token);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<EventLogic> events = context.watch<EventLogic>.fetchEvents(token);
//     return Scaffold(
//       appBar: AppBar(title: Text('Events')),
//       body: Consumer<EventLogic>(
//         builder: (context, eventsProvider, child) {
//           if (eventsProvider.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (eventsProvider.error != null) {
//             return Center(child: Text(eventsProvider.error!));
//           }

//           return ListView.builder(
//             itemCount: eventsProvider.events.length,
//             itemBuilder: (context, index) {
//               final event = eventsProvider.events[index];
//               return Card(
//                 child: Column(
//                   children: [
//                     Text(event.title, style: TextStyle(color: Colors.white),),
//                     Text(event.description, style: TextStyle(color: Colors.white),),
//                     // Add more details like organizer, sponsors, etc.
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }