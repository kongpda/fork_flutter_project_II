import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/widgets/event_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<Event> favoritedEvents = context.watch<EventLogic>().favoritedEvents;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color.fromARGB(255, 19, 23, 30),
        title: Text(
          'Favorites',
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 19, 23, 30),
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: Color(0xFF1A202C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'May 2014',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: favoritedEvents.isEmpty
                    ? Center(
                        child: Text(
                          'No favorite events yet',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: favoritedEvents.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(favoritedEvents[index]);
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return EventCard(
      date: event.attributes.startDate.toString(),
      title: event.attributes.title,
      imageUrl: event.attributes.featureImage,
      eventId: event.id,
      isFavorited: event.attributes.isFavorited,
      favoritesCount: event.attributes.favoritesCount ?? 0,
      toggleFavoriteUrl: event.links.toggleFavorite,
      onFavoriteToggled: () {
        // Refresh the favorites list
        context.read<EventLogic>().read(context);
      },
    );
  }
}
