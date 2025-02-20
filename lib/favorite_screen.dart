import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:provider/provider.dart';

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
        title: Text('Favorites', style: 
          TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
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
                  Text('May 2014', style: TextStyle(color: Colors.grey.shade300, fontSize: 18),)
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: favoritedEvents.length,
                  itemBuilder: (context, index){
                    return _buildPopularEventItem(favoritedEvents[index]);
                  },
                ),
              )
            ],
          ),
          ),
        ),
      );
  }
  Widget _buildPopularEventItem(Event slide){
    bool isFavorited = context.watch<EventLogic>().isFavorited;
    return _navigateToDetailScreen(
      slide,
      child: Card(
        color: Color(0xFF1A1D24),
        margin: EdgeInsets.only(bottom: 20,),
        child: Container(
        //padding: EdgeInsets.all(10),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(slide.attributes.featureImage,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slide.attributes.startDate.toString(), style: TextStyle(fontSize: 14, color: Color(0xFF455AF7)),),
                    SizedBox(height: 10),
                    Text(slide.attributes.title,maxLines: 2, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade400),),
                  ],
                ),
              ),
              IconButton(onPressed: (){
                context.read<EventLogic>().addFavorite(slide, context);
                context.read<EventLogic>().read(context);
                
              }, 
              icon: Icon(
                slide.attributes.isFavorited 
                  ? Icons.favorite 
                  : Icons.favorite_border_outlined,
                color: slide.attributes.isFavorited ? Colors.red : Colors.grey.shade700,
                size: 26,)
              ),
            ]
          ),
        ),
      ),
    );
  }
  Widget _navigateToDetailScreen(Event items,{Widget? child}){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => DetailScreen(items),)
        );
      },
      child: child,
    );
  }
}