import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/create/event_provider.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/api_module/event_participant_model.dart';
import 'package:flutter_project_ii/edit_screen.dart';
import 'package:flutter_project_ii/profile_module/profile_app.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  //const DetailScreen({super.key});
  final Event post;
  const DetailScreen(this.post);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  void initState() {
    super.initState();
    // Fetch event data when screen initializes
    Future.microtask(() => 
      context.read<EventLogic>().getEventDetail(context,widget.post.id)

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xFF1A202C),
        title: Text('Event Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 0, 0, 0),
              items: [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 10), 
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ).then((value) {
              if (value == 'edit') {
                // Handle edit action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEventScreen(event: widget.post, eventDetail: context.read<EventLogic>().eventDetail!),
                  ),
                );

              } else if (value == 'delete') {
                // Handle delete action  
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF1A202C),
                      title: Text('Delete Event'),
                      content: Text('Are you sure you want to delete this event?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () async {
                            await context.read<EventLogic>().deleteEvent(context, widget.post.id);
                            if (mounted) {
                              Navigator.of(context); // Close dialog
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileApp()
                              ),
                            ); // Navigate to profile screenឆ
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            });
            },
          ),
        ],
      ),
      body: Consumer<EventLogic>(
        builder: (context, provider, child) {
          final eventDetail = context.watch<EventLogic>().eventDetail;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(
              backgroundColor: Color(0xFF1A202C),
            ));
          }
          
          if (provider.error != '') {
            return Center(child: Text('Error: ${provider.error}'));
          }
          
          if (provider.eventDetail == '') {
            return const Center(child: Text('No event found'));
          }
      return Container(
        height: double.maxFinite,
        color: Color(0xFF1A202C),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(eventDetail?.data.attributes.featureImage ?? ''),
                
                SizedBox(height: 16),
                Text(
                  provider.eventDetail?.data.attributes.title ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '${provider.eventDetail?.data.attributes.startDate.toLocal().toString().split(' ')[0]} - ${provider.eventDetail?.data.attributes.endDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  provider.eventDetail?.data.attributes.location ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(provider.eventDetail?.data.relationships.user.profile.avatar ?? ''), // Add an image asset
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.eventDetail?.data.relationships.user.profile.firstName ?? '',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          provider.eventDetail?.data.relationships.organizer.attributes.name ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Follow',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  provider.eventDetail?.data.attributes.description ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: ()async {

                      final eventId = provider.eventDetail?.data.id;
                      print('Event ID:'+eventId.toString());
                        showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(child: CircularProgressIndicator());
                        },
                      );
                        final joinEvent = EventParticipant(
                          eventId: provider.eventDetail?.data.id ?? '',
                          userId: provider.eventDetail?.data.relationships.user.id ?? '',
                          status: "registered",
                          participationType: eventDetail?.data.attributes.participationType ?? '',
                          ticketTypeId: "2",
                          checkInTime: DateTime.now(),
                          joinedAt: DateTime.now(),

                        );
                        final success = await Provider.of<EventProvider>(context, listen: false)
                          .joinEvent(context, joinEvent);

                      Navigator.pop(context); // Dismiss loading indicator

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Join Event successfully!')),
                          
                        );
                        
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Navigate to home and clear stack
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to Join event')),
                        );
                      }
                        //context.read<EventLogic>()
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => QRCodeScreen(eventId: eventId),
                        //   ),
                        // );
                      },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Join Event',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
        }
      )
    );
  }
}