import 'package:flutter/material.dart';
import 'package:flutter_project_ii/slide_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF11151C),
        title: Text('Favorites', style: 
          TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF11151C),
        child: Container(
        padding: EdgeInsets.all(30),
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
          color: Color.fromARGB(255, 34, 40, 51),
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
                  itemCount: slideModelList.length-3,
                  itemBuilder: (context, index){
                    return _buildPopularEventItem(slideModelList[index]);
                  },
                ),
              )
            ],
          ),
          ),
        ),
      );
  }
  Widget _buildPopularEventItem(SlideModel slide){
    return Card(
      color: Color(0xFF1A1D24),
      margin: EdgeInsets.only(bottom: 20,),
      child: Container(
      padding: EdgeInsets.only(right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(slide.img,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slide.date, style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),),
                SizedBox(height: 10),
                Text(slide.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade400),),
              ],
            ),
            Spacer(),
            Icon(Icons.favorite, color: const Color.fromARGB(255, 186, 75, 1), size: 26,),
          ]
        ),
      ),
    );
  }
}