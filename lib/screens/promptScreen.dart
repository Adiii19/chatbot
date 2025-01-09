import 'dart:async';
import 'dart:convert';
import 'package:chatbot/models/user.dart';
import 'package:chatbot/screens/profileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';

class Promptscreen extends StatefulWidget {
  const Promptscreen({super.key});

  @override
  State<Promptscreen> createState() => _PromptscreenState();
}

class _PromptscreenState extends State<Promptscreen> with SingleTickerProviderStateMixin {
  GlobalKey responseKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _resultContainerKey = GlobalKey();
  FocusNode _focusNode = FocusNode();
  double? containerheight = 60;
  TextEditingController promptcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBrw3Nd9IWxPHgDTPBvT6YUQER1iWGTtc8';
  final header = {'Content-Type': 'application/json'};

  List<String> words = [];
  String result = '';
  bool isLoading = true;
  bool enteringprompt = false;
  int isUser  = 1;
  Timer? wordTimer;
  int currentWordIndex = 0;
  bool messagetapped = false;
  Icon? iconbutton= Icon(CupertinoIcons.waveform, size: 30, color: Colors.white);

 


  final MessageInfo status = MessageInfo(id: 1, Message: '');
  List<MessageInfo> MessageList = [];
  MessageInfo? message;

  Map<String, dynamic> createQuery() {
    return {
      "contents": [
        {
          "parts": [
            {"text": promptcontroller.text}
          ]
        }
      ]
    };
  }

  promptres() async {
    setState(() {
      isLoading=true;
      result = '';
      words = [];
      currentWordIndex = 0;
    });

 

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: header,
            body: jsonEncode(createQuery()),
          )
          .timeout(Duration(seconds: 30));
    
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        result = data['candidates'][0]['content']['parts'][0]['text'];
        MessageList.add(MessageInfo(
            id: 2,
            Message:
                result.toString().replaceAll("**", " ").replaceAll("*", " ")));
        words = result.replaceAll("**", " ").replaceAll("*", " ").split(' ');

        startWordAnimation();
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } on Exception catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startWordAnimation() {
    wordTimer?.cancel();
          _controller.reset();
   _controller.forward();
    wordTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (currentWordIndex < words.length) {
        setState(() {
          currentWordIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
  iconbutton=Icon(Bootstrap.soundwave, size: 30, color: Colors.white);
});

      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    wordTimer?.cancel();
    promptcontroller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MessageList.clear();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        
        leading: Padding(
          padding: const EdgeInsets.only(
            top: 20
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Profilescreen()),
              );
            },
            icon: Icon(Icons.notes, color: Colors.black),
          ),
        ),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20
            ),
            child: Icon(Icons.edit_square),
          ),
         
         
        ],
          bottom: PreferredSize(
    preferredSize: Size.fromHeight(1.0), // Height of the border
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromARGB(255, 133, 132, 132), // Border color
            width: 0.3, // Border thickness
          ),
        ),
      ),
    ),
  ),

        titleSpacing: 1,
        backgroundColor: Colors.white,
        
        title: enteringprompt
            ? Padding(
              padding: const EdgeInsets.only(
                top:20
              ),
              child: Text(
                  'ChatGPT',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
            )
            : 
               Padding(
                 padding: const EdgeInsets.only(top: 12),
                 child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: const Color.fromARGB(94, 224, 220, 250),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            'Get Plus',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 97, 48, 212),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Image(image: AssetImage('assets/images/gemini-logo.png'),height: 14,color:const Color.fromARGB(255, 97, 48, 212),),
                          ),
                        ],
                      ),
                    ),
                  ),
               ),
            
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: enteringprompt
                  ? StatefulBuilder(
                    builder:(context,setState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        controller: _scrollController,
                        itemCount: MessageList.length,
                        itemBuilder: (ctx, index) {
                          if (index < MessageList.length) {
                            if (MessageList[index].id == 1) {
                              return Align(
                                heightFactor: 2,
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        MessageList[index].Message.toString(),
                                        style: GoogleFonts.nunitoSans(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              );



                            } else {
                    
                              if(isLoading)
                              {
                                
                                return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                     CircleAvatar(
                                              radius: 15,
                                              backgroundImage: AssetImage("assets/images/chatgpt-logo.jpg"),
                                              foregroundColor: Colors.amber,
                                            ),
                                            AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) => CustomPaint(
                              size: const Size(30, 40),
                              painter: BouncingBallPainter(_animation.value),
                            ),
                          ),
                                  ],
                                ),
                              ),
                            );
                              }
                              
                        
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundImage: AssetImage("assets/images/chatgpt-logo.jpg"),
                                              foregroundColor: Colors.amber,
                                            ),
                                            SingleChildScrollView(
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 1,
                                                width: MediaQuery.of(context).size.width * 0.75,
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(0),
                                                      topRight: Radius.circular(20),
                                                      bottomLeft: Radius.circular(20),
                                                      bottomRight: Radius.circular(20)),
                                                ),
                                                child: Text(
                                                  
                                                  index == MessageList.length - 1
                                                      ? words.take(currentWordIndex).join(' ')
                                                      : MessageList[index].Message.toString(),
                                                  style: 
                                                  GoogleFonts.nunitoSans(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                        }
                            }
                          
                             
                          
                        },
                      );
                    }
                  )
                  : Center(
                      child: Image(
                        image: AssetImage('assets/images/chatgpt-faint.png'),
                        height: 40,
                      ),
                    ),
            ),

            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: containerheight,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(messagetapped ? 30: 60),
                    color: const Color.fromARGB(255, 245, 244, 244)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        messagetapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      
                                    });
                                  },
                                  focusNode: _focusNode,
                                  maxLines: null,
                                  controller: promptcontroller,
                                  style: GoogleFonts.nunitoSans(
                                      color: const Color.fromARGB(255, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    filled: true,
                                    fillColor: const Color.fromARGB(255, 245, 244, 244),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: const Color.fromARGB(44, 255, 255, 255),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: const Color.fromARGB(0, 255, 255, 255),
                                      ),
                                    ),
                                    hintText: "Message",
                                    hintStyle: GoogleFonts.nunitoSans(
                                      color: const Color.fromARGB(255, 78, 78, 78),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(height: 0),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    
                                      color: const Color.fromARGB(0, 224, 224, 224)),
                                  child: Icon(
                                    Bootstrap.plus,
                                    size: 30,
                                    weight: 10,
                                    color: Colors.black,
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Bootstrap.globe,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 60),
                                child: messagetapped
                                    ? SizedBox(width:140,)
                                    : Row(
                                      
                                      children: [
                                        

                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                containerheight = 110;
                                                messagetapped = true;
                                                _focusNode.requestFocus();
                                              });
                                            },
                                            child:messagetapped?SizedBox(width: MediaQuery.of(context).size.width * 0.35,): Container(
                                              width: MediaQuery.of(context).size.width * 0.35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 245, 244, 244)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Message"),
                                              ),
                                            ),
                                          ),
                                         
                                      ],
                                    ),
                              ),
                               Icon(CupertinoIcons.mic,size: 30,),
                               SizedBox(width:15,),
                              messagetapped ? SizedBox(width: 10) : SizedBox(width: 0),
                              InkWell(
                                onTap: () {
                                  promptres();
                                  
                                  MessageList.add(
                                      MessageInfo(Message: promptcontroller.text, id: 1));
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    promptcontroller.clear();
                                    iconbutton=Icon(Bootstrap.stop_circle,color: Colors.white,size: 30,);
                                    scrollToBottom();
                                    enteringprompt = true;
                                   
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(255, 0, 0, 0)),
                                  child: promptcontroller.text.isEmpty?iconbutton:
                                       Icon(Bootstrap.arrow_up_circle, size: 30, color: Colors.white)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingBallPainter extends CustomPainter {
  final double animation;

  BouncingBallPainter(this.animation);

  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      20 - (20 * animation),
      Paint()..color = const Color.fromARGB(255, 0, 0, 0),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every time the animation value changes
  }
}