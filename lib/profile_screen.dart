import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:flutter_project_ii/slide_model.dart';

enum ChangeWidget {
  grid,
  tickets,
  setting,
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
        color: Color(0xFF1A202C),
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
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 10,right: 10),
                      decoration:selectedWidget == ChangeWidget.grid ? BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey),),
                      ) : null,
                      child: IconButton(onPressed: (){
                        setState(() {
                          selectedWidget = ChangeWidget.grid;
                        });
                      }, 
                        icon: Icon(Icons.grid_on, size: 30),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 10,right: 10),
                      decoration:selectedWidget == ChangeWidget.tickets ? BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey),),
                      ) : null,
                      child: IconButton(onPressed: (){
                        setState(() {
                          selectedWidget = ChangeWidget.tickets;
                        });
                      },
                        icon: Icon(CupertinoIcons.ticket, size: 35)
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 10,right: 10),
                      decoration:selectedWidget == ChangeWidget.setting ? BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey),),
                      ) : null,
                      child: IconButton(onPressed: (){
                        setState(() {
                        selectedWidget = ChangeWidget.setting;
                        });
                      },
                        icon:Icon(Icons.settings_applications_outlined, size: 35)
                      ),
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
      case ChangeWidget.tickets:
        return _buildTicketsItem();
      case ChangeWidget.setting:
        return _buildSettingItem();
    }
  }
  Widget _buildTicketsItem(){
    return Container();
  }

  Widget _buildSettingItem(){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 40,),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(Icons.notifications_none, color: Color(0xFF455AF7),)
              ),
              SizedBox(width: 30,),
              Text("Notifications", style: 
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.navigate_next_sharp, color: Colors.grey.shade500,size: 34,)
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(Icons.person_outline_outlined, color: Color(0xFF455AF7),)
              ),
              SizedBox(width: 30,),
              Text("Personal Information", style: 
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.navigate_next_sharp, color: Colors.grey.shade500,size: 34,)
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(Icons.translate, color: Color(0xFF455AF7),)
              ),
              SizedBox(width: 30,),
              Text("Language", style: 
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Spacer(),
              Text('English', style: TextStyle(color: Colors.grey.shade500),),
              SizedBox(width: 10,),
              Icon(Icons.navigate_next_sharp, color: Colors.grey.shade500,size: 34,)
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(Icons.settings, color: Color(0xFF455AF7),)
              ),
              SizedBox(width: 30,),
              Text("Setting", style: 
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.navigate_next_sharp, color: Colors.grey.shade500,size: 34,)
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(Icons.question_mark_rounded, color: Color(0xFF455AF7),)
              ),
              SizedBox(width: 30,),
              Text("FAQ", style: 
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.navigate_next_sharp, color: Colors.grey.shade500,size: 34,)
            ],
          ),
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
  Widget _navigateToDetailScreen(SlideModel post,{Widget? child}){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => DetailScreen(post),)
        );
      },
      child: child,
    );
  }
  
}