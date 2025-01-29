import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF11151C),
        title: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Row(
            children: [
              Image(image: Image.asset('assets/Wegocolor.png').image, height: 45,),
            ],),
            
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search, color: Colors.white, size: 35,),
            
          ),
          Stack(
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.notifications_none, color: Colors.white, size: 35,),
              ),
              Positioned(
                right: 10,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text('0', style: TextStyle(color: Colors.white, fontSize: 15),),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Color(0xFF11151C),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
          SizedBox(height: 10),
            Row(
              children: [
                Text(
                    'Featured',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),  
          SizedBox(height: 10),
          ListView.builder(itemBuilder: (context, index) {
            return Container(
              
            );
          },
          ),
            
          SizedBox(height: 10),
          Text(
            'Popular Destinations',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          //_buildPopularDestinations(),
          SizedBox(height: 10),
          Text(
            'Featured Destinations',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
          ),
        ],
        ),
      ),
    );
  }
}