import 'package:flutter/material.dart';
import 'package:flutter_project_ii/category_module/category_model.dart';
import 'package:flutter_project_ii/category_module/category_service.dart';
import 'package:provider/provider.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Categories> record = context.watch<CategoryLogic>().category;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A202C),
        title: Text('All Events', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),       
        actions: [
          Icon(Icons.search, color: Colors.white),
        ],
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF1A202C),
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Interests', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 30),),
            Text('Choose your favorite interest to shows all in one place related to it.', 
            style: TextStyle(fontSize: 20,color: Colors.grey.shade500,)),
            SizedBox(height: 20,),
            Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                  ),
                  itemCount: record.length,
                  itemBuilder: (context, index) {
                  return  _buildCategory(record[index]);
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(Categories category) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFF27303F),
      ),
      child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(image: NetworkImage("https://images.pexels.com/photos/716276/pexels-photo-716276.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
            ),
            SizedBox(height: 10,),
            Text(category.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            Text("25 Events", style: TextStyle(color: Colors.grey.shade600, fontSize:18)),
            
          ],
        ),
          // Navigate to specific category screen
    );
  }

}