import 'package:flutter/material.dart';
import 'package:flutter_project_ii/language_data.dart';
import 'package:flutter_project_ii/language_logic.dart';
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
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.all(30),
        child: Container(
          color: Color(0xFF1E2630),
        padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey),), 
                      ),
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Khmer', style:TextStyle(color: Colors.white,fontSize: 22)),
                            Text('ភាសាខ្មែរ', style:TextStyle(color: Colors.white))
                          ]
                        ),
                        onTap: () {
                        context.read<LanguageLogic>().changeToKh();
                        },
                         trailing: _langIndex == 1 ? const Icon(Icons.check, color: Color(0xFF455AF7),) : null,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey),), 
                      ),
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('English', style:TextStyle(color: Colors.white,fontSize: 22)),
                            Text('English', style:TextStyle(color: Colors.white))
                          ]
                        ),
                        onTap: () {
                        context.read<LanguageLogic>().changeLanguage();
                        },
                         trailing: _langIndex == 0 ? const Icon(Icons.check, color: Color(0xFF455AF7)) : null,
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