import 'package:flutter/material.dart';
import 'package:flutter_project_ii/profile_module/language_data.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  //Language _lang = Language();
  int _langIndex = 0;
  @override
  Widget build(BuildContext context) {
    Language _lang = context.watch<LanguageLogic>().language;
    int _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xFF1A202C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _lang.language,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF1A202C),
        padding: EdgeInsets.all(20),
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:_langIndex == 1 ? Color(0xFF27303F) : null,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.grey.shade800)
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color:_langIndex == 1 ? Color(0xFF1A202C): Color(0xFF27303F),
                          ),
                          child: Image(image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Flag_of_Cambodia.svg/640px-Flag_of_Cambodia.svg.png"),)
                        ),
                        horizontalTitleGap: 30,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Khmer', style:TextStyle(color: Colors.white,fontSize: 20)),
                            Text('ភាសាខ្មែរ', style:TextStyle(color: Colors.white))
                          ]
                        ),
                        onTap: () {
                        context.read<LanguageLogic>().changeToKh();
                        },
                         trailing: _langIndex == 1 ? const Icon(Icons.check_box_outlined, color: Color(0xFF455AF7),size: 35,) : Icon(Icons.check_box_outline_blank_sharp,size: 35),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:_langIndex == 0 ? Color(0xFF27303F) : null,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.grey.shade800)
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color:_langIndex == 0 ? Color(0xFF1A202C): Color(0xFF27303F),
                          ),
                          child: Image(image: NetworkImage("https://cdn.britannica.com/33/4833-050-F6E415FE/Flag-United-States-of-America.jpg"),)
                        ),
                        horizontalTitleGap: 30,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('English', style:TextStyle(color: Colors.white,fontSize: 20)),
                            Text('English', style:TextStyle(color: Colors.white))
                          ]
                        ),
                        onTap: () {
                        context.read<LanguageLogic>().changeLanguage();
                        },
                         trailing: _langIndex == 0 ? const Icon(Icons.check_box_outlined, color: Color(0xFF455AF7),size: 35,) : Icon(Icons.check_box_outline_blank_sharp,size: 35),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}