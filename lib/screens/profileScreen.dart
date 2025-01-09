import 'dart:io';

import 'package:chatbot/screens/promptScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profilescreen extends StatefulWidget {
  Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  late File? image;

  chooseimage() async {
    ImagePicker picker = ImagePicker();
    final XFile? selectedimage =
        await picker.pickImage(source: ImageSource.gallery);
    if (selectedimage != null) {
      image = File(selectedimage.path);
      image;
    }
  }

  clickimage() async {
    ImagePicker picker = ImagePicker();
    final XFile? selectedimage =
        await picker.pickImage(source: ImageSource.camera);
    if (selectedimage != null) {
      image = File(selectedimage.path);
      image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text('Profile',
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              color: const Color.fromARGB(255, 0, 0, 0),
            )),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Aditya Mhatre",
              style: GoogleFonts.nunitoSans(fontSize: 30, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 7,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal,
                        color: Color.fromARGB(234, 0, 0, 0),
                        offset: Offset(3, 2))
                  ],
                  borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                onPressed: () => {
                  showDialog(
                    
                      context: context,
                      builder: (context) {
                        
                        return AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          title: Text("Choose your source",
                              style: GoogleFonts.outfit(
                                  fontSize: 30, color: const Color.fromARGB(255, 255, 255, 255))),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(),
                                    onPressed: () {
                                      clickimage();
                                    }, child: Text("Camera",style: GoogleFonts.outfit(
                                  fontSize: 20, color: const Color.fromARGB(255, 4, 29, 7)))),
                                  ElevatedButton(
                                    onPressed: () {
                                      chooseimage();
                                    }, child: Text("Gallery",style: GoogleFonts.outfit(
                                  fontSize: 20, color: const Color.fromARGB(255, 4, 29, 7))))
                              ],
                            )
                          ],
                        );
                      })
                },
                child: Text(
                  "Upload Images",
                  style: GoogleFonts.nunitoSans(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
