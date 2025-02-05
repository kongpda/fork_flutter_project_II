import 'package:flutter/material.dart';
import 'package:flutter_project_ii/slide_model.dart';

enum ChangeWidget {
  grid,
  reels,
  tagged,
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ChangeWidget selectedWidget = ChangeWidget.grid;
  bool isSelected = false;
  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: Color(0xFF11151C),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              SizedBox(height: 150,),
              
              Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage("https://images.pexels.com/photos/2080383/pexels-photo-2080383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                ),
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Text("Adam John Levine", style: 
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  Text("Levineadam@mail.com", style: TextStyle(color: Colors.grey.shade400),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        selectedWidget = ChangeWidget.grid;
                        BorderSide(color: Color(0xFF7F7F7F));
                      });
                    }, 

                      icon: isSelected ? Icon(Icons.grid_on, size: 30) : Icon(Icons.grid_off_rounded, size: 30),

                      
                    ),
                      
                    IconButton(onPressed: (){
                      setState(() {
                        selectedWidget = ChangeWidget.reels;
                      });
                    },
                      icon: Icon(Icons.view_sidebar_outlined, size: 30)
                    ),
                    IconButton(onPressed: (){
                      setState(() {
                      selectedWidget = ChangeWidget.tagged;
                      });
                    },
                      icon:Icon(Icons.person_pin_outlined, size: 30)
                    ),
                  ],
                ),
              ),

              Container(
                child: _buildChangeBodyProfile()
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildChangeBodyProfile(){
    switch (selectedWidget) {
      case ChangeWidget.grid:
        return _buildGridItem();
      case ChangeWidget.reels:
        return _buildReelsItem();
      case ChangeWidget.tagged:
        return _buildTaggedItem();
    }
  }
  Widget _buildReelsItem(){
    return Container();
  }

  
  Widget _buildReelsItems(String url){
    return _navigateToDetailReel(AutofillHints.url);
    
  }
  Widget _navigateToDetailReel(String url,{Widget? child}){
    return InkWell(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ReelsDetailScreen()));
      },
      child: child,
    );
  }
  Widget _buildTaggedItem(){
    return Center(
      child: Column(
        children: [
          Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Icon(Icons.person_pin_outlined,size: 100, weight: 16,),
          ),
          
        ),
        SizedBox(height: 20),
        Container( 
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Photos and Videos of you', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text('When you are tagged in photos, they will appear here.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            ],
          )
        )
        ],
      ),
    );
  }

  Widget _buildGridItem(){
    return GridView.builder(
      shrinkWrap: true,
      itemCount: slideModelList.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return _buildPostItem(slideModelList[index]);
      },
    );
  }

  Widget _buildPostItem(SlideModel post) {
    return _navigateToDetailScreen(
      post,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.img),
            fit: BoxFit.cover,
          ),
        ),
        
      ),
    );
  }
  Widget _navigateToDetailScreen(SlideModel url,{Widget? child}){
    return InkWell(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(url)));
      },
      child: child,
    );
  }
}