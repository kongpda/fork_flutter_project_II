import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/detail_model.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/qr_screen.dart';
import 'package:intl/intl.dart';
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
        title: Text('Event Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<EventLogic>(
        builder: (context, provider, child) {
          final eventDetail = context.watch<EventLogic>().eventDetail;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.error != '') {
            return Center(child: Text('Error: ${provider.error}'));
          }
          
          if (provider.eventDetail == '') {
            return const Center(child: Text('No event found'));
          }
      return SingleChildScrollView(
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
                  onPressed: () {
                    final eventId = provider.eventDetail?.data.id;
                    if (eventId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeScreen(eventId: eventId),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Join Event',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
        }
      )
    );
  }
}