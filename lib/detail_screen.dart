import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/create/event_provider.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/api_module/event_participant_model.dart';
import 'package:flutter_project_ii/qr_screen.dart';
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
      
      body: Consumer<EventLogic>(
        builder: (context, provider, child) {
          List<Event> isPaticipant = context.watch<EventLogic>().eventParticipant;
          debugPrint(widget.post.attributes.isParticipant.toString());
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
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 69, 69, 70),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                    Text(
                      'Event Detail',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Image.network(eventDetail?.data.attributes.featureImage ?? ''),
                
                SizedBox(height: 16),
                Text(
                  provider.eventDetail?.data.attributes.title ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          provider.eventDetail?.data.relationships.organizer.attributes.name ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Follow',
                    //     style: TextStyle(color: Colors.blue),
                    //   ),
                    // ),
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

                      
                      
                        final joinEvent = EventParticipant(
                          status: "registered",
                          participationType: eventDetail?.data.attributes.participationType ?? '',
                          ticketTypeId: "2",

                        );
                        final success = await Provider.of<EventProvider>(context, listen: false)
                          .joinEvent(context,widget.post.id, joinEvent);

                      Navigator.pop(context); // Dismiss loading indicator
                        context.read<EventLogic>().read(context);

                      if (success) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Join Event successfully!')),
                          
                        // );
                        if(widget.post.attributes.isParticipant == true){
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => QRCodeScreen(eventId: widget.post.id))
                        );
                        }else{
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Navigate to home and clear stack
                        }
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
                    child: widget.post.attributes.isParticipant ?? false  ? Text('Join Event',style: TextStyle(color: Colors.white),) : 
                    Text('Leave Event',style: TextStyle(color: Colors.white),),
                    
                      
                    
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