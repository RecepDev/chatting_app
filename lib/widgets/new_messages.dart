
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugar/sugar.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.gelenId});
  final String gelenId;

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  late String _jwt;
  var _messageController = TextEditingController();

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
  final response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/America/New_York'));
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

setJwt(String time){
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

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.gelenId)
        .collection('aaa')
        .add({
      'text': enteredMessage,
      'createdAt': FieldValue.serverTimestamp(),
    //  getJwtData(),
      //DateFormat.Hms().format(setup()),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: [
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
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusColor: Colors.black,
              hoverColor: Colors.black26,
              labelText: 'send a message...',),
          ),
        ),
        IconButton(
          
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.send),
          onPressed: _submitMessage,
        ),
      ]),
    );
  }
}
