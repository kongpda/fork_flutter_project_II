import 'package:flutter/material.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        color: Color(0xFF1A202C),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              SizedBox(height: 50,),
              
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
              SizedBox(height: 30,)
,              Column(
                children: [
                  _buildUsernameInput(),
                  SizedBox(height: 30,),
                  _buildEmailInput(),
                  SizedBox(height: 30,),
                  _buildPasswordInput(),
                  SizedBox(height: 80,),
                  __buildSaveButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildUsernameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Username",style: TextStyle(fontSize: 18,color: Colors.white),),
        SizedBox(height: 15,),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person_outline_sharp,color: Colors.white,),
                  hintText: 'Adam John Levine',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
            ],
          )
        ),
      ],
    );
  }
  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email",style: TextStyle(fontSize: 18,color: Colors.white),),
        SizedBox(height: 15,),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.email_outlined,color: Colors.white,),
                  hintText: 'Levineadam@mail.com',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
            ],
          )
        ),
      ],
    );
  }
  bool _hidePassword = true;
  Widget _buildPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password",style: TextStyle(fontSize: 18,color: Colors.white),),
        SizedBox(height: 15,),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline_rounded,color: Colors.white,),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      _hidePassword =!_hidePassword;
                    });
                  }, 
                  icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility) )       
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                autocorrect: false,
                obscureText: _hidePassword,
              ),
            ],
          )
        ),
      ],
    );
  }
  Widget __buildSaveButton(){
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0466C8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Save Change', style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}