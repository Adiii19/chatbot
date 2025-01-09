import 'package:chatbot/screens/promptScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  String value = "";
  bool isAnimating = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool islogin = false;
  bool isauthenticating = false;

  

  void submit() async {
  
      setState(() {
        isauthenticating = true;

      });

      try {

        if(islogin){
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailcontroller.text, 
            password: passwordcontroller.text);

            ScaffoldMessenger.of(context).showSnackBar(

              SnackBar(content: Text('Login Successful'),duration: Duration(seconds: 1),));
           
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Promptscreen()));
              islogin=false;
        }
        else{
          await firebaseAuth.createUserWithEmailAndPassword(email:emailcontroller.text,password: passwordcontroller.text);
        }

        emailcontroller.clear();
        passwordcontroller.clear();
      } on FirebaseAuthException catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message??'Authentication Failed')));
      }finally{
        setState(() {
          isauthenticating = false;
        });
      }

    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    islogin=false;
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        value = "ChatGPT";
        isAnimating = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
                opacity: isAnimating ? 1.0 : 0.0,
                duration: Duration(milliseconds: 2500),
                curve: Curves.linear,
                child: AnimatedScale(
                    duration: Duration(milliseconds: 1000),
                    scale: isAnimating ? 1.0 : 0.98,
                    curve: Curves.ease,
                    child: Text(
                      value,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black87, fontSize: 50),
                    ))),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                  controller: emailcontroller,
                  style: TextStyle(color: Colors.black),
                  
                  decoration: InputDecoration(
                     border: OutlineInputBorder(
                        
                        borderRadius:
                            BorderRadius.circular(8), // Change the radius here
                        borderSide: BorderSide(
                          width: 1,
                          color: const Color.fromARGB(255, 255, 255, 255), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          
                          color: const Color.fromARGB(255, 254, 254, 254), // Focused border color
                        ),
                      ),
                    label: Text(
                      "Email",
                      style: GoogleFonts.outfit(
                          color: const Color.fromARGB(255, 115, 115, 115),
                          fontSize: 14,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
            ),
            
            SizedBox(
              height: 30,
            ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        
                        borderRadius:
                            BorderRadius.circular(8), // Change the radius here
                        borderSide: BorderSide(
                          width: 1,
                          color: const Color.fromARGB(255, 255, 255, 255), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          
                          color: const Color.fromARGB(255, 255, 255, 255), // Focused border color
                        ),
                      ),
                    label: Text(
                      "Password",
                      style: GoogleFonts.outfit(
                          color: const Color.fromARGB(255, 115, 115, 115),
                          fontSize: 14,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
           ),
            
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.normal,
                          color: Color.fromARGB(234, 7, 15, 7),
                          offset: Offset(7, 2))
                    ],
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                  onPressed: () => {
                         submit()
                         
                  },
                  child: Text(
                    islogin?"Login":"Sign-Up",
                    style: GoogleFonts.nunitoSans(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                setState(() {
                  islogin=true;
                });
              },
              child: Text("Already registered? Login",style: TextStyle(
                color: Colors.blue
              ),),
            )
          ],
        ),
      ),
    );
  }
}
