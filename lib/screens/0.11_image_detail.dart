import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen(
      {super.key, required this.secilenImage, required this.chatId});

  final File secilenImage;
  final String chatId;

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late TextEditingController controller;
  late String userUid;

  @override
  void initState() {
    super.initState();
    userUid = FirebaseAuth.instance.currentUser!.uid;

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.hd,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.rotate_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.sticky_note_2_rounded,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.text_fields,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                top: 55,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Image.file(widget.secilenImage),
                ),
              ),
              Positioned(
                bottom: 65,
                child: SizedBox(
                  height: 48,
                  width: 380,
                  child: Container(
                    //color: Colors.grey,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Theme.of(context).colorScheme.primary),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: SizedBox(
                            width: 25,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.add_photo_alternate_rounded),
                              style: const ButtonStyle(
                                iconColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
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
                        Padding(
                          padding: const EdgeInsets.only(right: 13),
                          child: SizedBox(
                            width: 25,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              icon: const Icon(Icons.access_time_outlined),
                              style: const ButtonStyle(
                                iconColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(22)),
                    child: IconButton(
                        onPressed: _sendImage,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //color: Colors.grey,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Theme.of(context).colorScheme.primary),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'aaa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$userUid.jpg');
    await storageRef.putFile(widget.secilenImage);
    final imageUrl = await storageRef.getDownloadURL();
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': controller.text,
      'createdAt': FieldValue.serverTimestamp(),
      //  getJwtData(),
      //DateFormat.Hms().format(setup()),
      'textImage': imageUrl,
      'userId': userUid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    Navigator.of(context).pop();
  }
}
