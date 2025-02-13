import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  //const DetailScreen({super.key});

  Event post;
  DetailScreen(this.post, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A202C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
        child: Column(children: [
          Positioned(
            child: Container(
              padding: const EdgeInsets.only(right: 50),
              child: Column(children: [
                Text(widget.post.attributes.title,
                style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
            ),
          )
        ]),
      )),
      body: _buildPost(),
      
    
    );
  }

  Widget _buildPost() {
    return Container(
      color: Color(0xFF1A202C),
      child: _buildPostItem(),
    );
  }

  Widget _buildPostItem(){
    return Column( 
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://images.pexels.com/photos/30238700/pexels-photo-30238700/free-photo-of-woman-enjoying-a-latte-in-a-cozy-cafe.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
          ),
          title: Row(
            children: [
              Text(
                'ery_blp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white
                ),
              ),
            ],
          ),
          subtitle: Text(widget.post.attributes.address, style: TextStyle(color: Colors.grey.shade400),),
          trailing: ElevatedButton(onPressed: (){}, 
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF455AF7),foregroundColor: Colors.white),
            child: Text("Join"))
        ),
        // Post image
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.post.attributes.featureImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Post actions
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white,),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.comment_outlined, color: Colors.white,),
              onPressed: () {},
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(DateFormat('dd MMM, yyyy').format(DateTime.parse(widget.post.attributes.startDate.toString())), style: TextStyle(color: Color(0xFF455AF7), fontSize: 18),),
            ),
          ],
        ),
        // Likes
         Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '24 like',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: RichText(
            text: TextSpan(
              style: TextStyle(),
              children: [
                TextSpan(
                  text: 'ery_blp ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.post.attributes.description,
                ),
                
              ],
            ),
          ),
        ),
        // Time
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '4 days ago',
            style: TextStyle(
              fontSize: 12, color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}