import 'dart:io';

import 'package:chatting_app/screens/0.11_image_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sugar/sugar.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewMessage extends StatefulWidget {
  const NewMessage(
      {super.key, required this.gelenId, required this.gelenChatName});
  final String gelenId;
  final String gelenChatName;

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  late String _jwt;
  final _messageController = TextEditingController();
  late File secilenImage;

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  String getUTCDateTime() {
    //String<Timezone> timezone = 'Europe/Istanbul';
    ZonedDateTime now = ZonedDateTime.now(Timezone('Europe/Istanbul'));
    var formatter = DateFormat.Hm();
    return now.toString();
  }

  Future<void> fetchNewYorkTime() async {
    final response = await http.get(
        Uri.parse('http://worldtimeapi.org/api/timezone/America/New_York'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String newYorkTime = data['datetime'];
      print('New York Saati: $newYorkTime');
      setJwt(newYorkTime);
    } else {
      throw Exception('New York saat bilgisini alirken hata oluştu.');
    }
  }

  getJwtData() {
    fetchNewYorkTime();
    return _jwt;
  }

  setJwt(String time) {
    _jwt = time;
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    //  Focus.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chats').doc(widget.gelenId).update({
      'isEmpty': true,
    });

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.gelenId)
        .collection('messages')
        .add({
      'text': enteredMessage,
      'createdAt': FieldValue.serverTimestamp(),
      'textImage': 'false',
      //  getJwtData(),
      //DateFormat.Hms().format(setup()),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.gelenChatName)
        .update({'newTextTime': FieldValue.serverTimestamp()});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 1, bottom: 14),
      child: SizedBox(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        child: Row(children: [
          Expanded(
            child: Container(
              //color: Colors.grey,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Theme.of(context).colorScheme.primary),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white70),
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        hintText: 'Message',
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Wrap(
                    spacing: 0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: SizedBox(
                          width: 25,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: _pickImageGallery,
                            icon: const Icon(Icons.photo),
                            style: const ButtonStyle(
                              iconColor: MaterialStatePropertyAll(Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SizedBox(
                          width: 25,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: _pickImageCamera,
                            icon: const Icon(Icons.camera_alt_sharp),
                            style: const ButtonStyle(
                              iconColor: MaterialStatePropertyAll(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                color: Theme.of(context).colorScheme.primary),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.send),
              onPressed: _submitMessage,
            ),
          ),
        ]),
      ),
    );
  }

  void _pickImageCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (pickedImage == null) {
      return;
    }
    secilenImage = File(pickedImage.path);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageDetailScreen(
          secilenImage: secilenImage, chatId: widget.gelenChatName),
    ));
    // widget.onPickImage(_pickedImageFile!);
  }

  void _pickImageGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedImage == null) {
      return;
    }
    secilenImage = File(pickedImage.path);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageDetailScreen(
          secilenImage: secilenImage, chatId: widget.gelenChatName),
    ));
    // widget.onPickImage(_pickedImageFile!);
  }
}
