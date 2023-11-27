import 'dart:ffi';
import 'dart:io';

import 'package:chatting_app/screens/-home_page.dart';
import 'package:chatting_app/widgets/group_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
    required this.gelenGrupUyeleri,
    required this.selectionMapOfId,
    required this.gelenMap,
  });

  final List<dynamic> gelenGrupUyeleri;
  final List<String> selectionMapOfId;
  final Map<String, Map<String, dynamic>> gelenMap;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  File? _selectedImage;
  final _form = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String myName = '';
  List<Map<String, dynamic>> resultList = [];

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  yeniMethod() async {
    _selectedImage ??= await getImageFileFromAssets('images/group.jpeg');
  }

  void _submit(
      List<dynamic> gelenGrupUyeleri, List<String> selectionMapOfId) async {
    await yeniMethod();
    var randomId = const Uuid().v4();

    String enteredtextt = _messageController.text;
    User? user = FirebaseAuth.instance.currentUser;

    // await yeniMethod();
    // final isValid = _form.currentState!.validate();

    if (_selectedImage == null) {
      return;
    }

    _form.currentState!.save();
    selectionMapOfId.add(user!.uid);
    //selectionMap.addAll({'${user!.email}' : true });
    gelenGrupUyeleri.add(user.email);
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('group_images')
          .child('$enteredtextt.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        myName = value['username'];
      });
      /* widget.gelenMap.forEach((key, value) {
        resultList.add(value);
        //  print(arrayList);
      }); */
      FirebaseFirestore.instance.collection('chats').doc(randomId).set({
        // 'users' : gelenGrupUyeleri,
        'isGroup': true,
        'isEmpty': true,
        'creatorId': user.uid,
        'creatorEmail': user.email,
        'creatorImageUrl': imageUrl,
        'creatorUsername': myName,
        'users': gelenGrupUyeleri,
        'chatId': const Uuid().v4(),
        'toimageUrl': imageUrl,
        'toEmail': 'bbb',
        'toUsername': enteredtextt,
        'owner': selectionMapOfId,
        'usersMap': widget.gelenMap,
        // 'owner' : userId,
        'newTextTime': DateTime.now(),
        'createdAt': DateTime.now(),
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          leadingWidth: 50,
          titleSpacing: 1,
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'New group',
            style: TextStyle(color: Colors.white),
          )),
      body: Stack(
        children: [
          Column(
            children: [
              Form(
                key: _form,
                child: Row(
                  children: [
                    GroupImagePicker(
                      onPickImage: (pickedImage) {
                        _selectedImage = pickedImage;
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusColor: Colors.black,
                          hoverColor: Colors.black26,
                          labelText: 'New Group Name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Disappearing Messages'),
                subtitle: const Text('Off'),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.timelapse_rounded)),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Group permissions'),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.settings)),
              )
            ],
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 11,
                    spreadRadius: 1,
                    color: Colors.grey.shade600,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                iconSize: 55,
                onPressed: () {
                  debugPrint(_messageController.text);
                  _submit(widget.gelenGrupUyeleri, widget.selectionMapOfId);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomePage()), // Replace NewScreen with the screen you want to navigate to.
                    (Route<dynamic> route) =>
                        false, // Use this condition to remove all previous routes.
                  );
                },
                icon: const Icon(Icons.check, size: 35, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
