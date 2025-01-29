import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF11151C),
        title: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 31, 36, 45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child:
              IconButton(onPressed: (){}, 
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 20,),
            style: ButtonStyle(alignment: Alignment.center,),
          ),
          )
        ),
      ),
      body: Container(
        color: Color(0xFF11151C),
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Sign Up", style: TextStyle(fontSize: 28, color: Colors.white)),
            SizedBox(height: 20),
            SizedBox(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Colors.grey.shade600, size: 25),
                        hintText: 'Username',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                      padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email_outlined, color: Colors.grey.shade600, size: 25),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                      padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_open_outlined, color: Colors.grey.shade600, size: 25),
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                        border: InputBorder.none,
                        suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye, color: Colors.grey.shade600, size: 25)),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                    
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            SizedBox(
              child: Column(
                children: [
                  SizedBox(
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
                      child: const Text('Sign Up', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 50),
                  Column(
                    children: [
                      Text('Or Sign up with', style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apple, color: Colors.black, size: 30),
                          SizedBox(width: 10),
                          Text('Continue With Apple',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                        ],
                      )
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network('https://img.icons8.com/?size=100&id=17949&format=png&color=000000', width: 25, height: 25),
                          SizedBox(width: 10),
                          Text('Continue With Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            Column(
              children: [
                Text('By signing up or logging in, I accept the Event', style: TextStyle(color: Colors.grey.shade500)),
                Text('Term of Service ', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
