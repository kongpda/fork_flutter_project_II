import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:provider/provider.dart';

class AllEventScreen extends StatefulWidget {
  const AllEventScreen({super.key});

  @override
  State<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends State<AllEventScreen> {
  @override
  Widget build(BuildContext context) {
    List<Event> record = context.watch<EventLogic>().records;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 19, 23, 30),
        title: Text("All Events", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 19, 23, 30),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF1A202C),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(CupertinoIcons.search, size: 35, color: Colors.white,),
                        border: InputBorder.none,
                        hintText: 'Search Event in...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 20)
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: record.length,
                  itemBuilder: (context, index){
                  return _buildPopularEventItem(record[index]);
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
    return _navigateToDetailScreen(
      slide,
      child: Card(
        color: Color(0xFF1A1D24),
        margin: EdgeInsets.only(bottom: 20,),
        child: Container(
        padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(slide.attributes.featureImage,
                width: 100,
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
              Spacer(),
              Icon(Icons.favorite_border_outlined, color: Colors.grey.shade700, size: 26,),
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