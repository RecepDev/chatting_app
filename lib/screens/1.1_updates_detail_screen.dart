import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/widgets/show_update_photos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatesDetailScreen extends StatefulWidget {
  const UpdatesDetailScreen(this.name, this.url, this.email, this.photoList,
      this.time, this.snapshot, this.index, this.uid,
      {super.key});
  final String name;
  final String email;
  final List<dynamic> photoList;
  final String time;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final int index;
  final String uid;

  final String url;
  @override
  State<UpdatesDetailScreen> createState() => _UpdatesDetailScreenState();
}

class _UpdatesDetailScreenState extends State<UpdatesDetailScreen> {
  int verilecekInt = 0;
  late List<String> items;
  String? currentUserEmail;
  String? userUid;
//  late int myindex;

  @override
  Widget build(BuildContext context) {
    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.url),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  )
                ],
              )
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            PopupMenuButton(
                shadowColor: Colors.grey.shade600,
                icon: const Icon(Icons.more_vert,
                    color: Colors.white), // add this line
                itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Mute',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Message',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Voice call',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Video call',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'View contact          ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        padding: const EdgeInsets.all(1),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Report',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                onSelected: (index) async {
                  switch (index) {
                    case 'report':
                      // showDialog(
                      //     barrierDismissible: true,
                      //     context: context,
                      //     builder: (context) => ReportUser(
                      //       currentUser: widget.sender,
                      //       seconduser: widget.second,
                      //     )).then((value) => Navigator.pop(ct))
                      break;
                  }
                })
          ]),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 96,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.5,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 1),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 55,
                  height: MediaQuery.of(context).size.height - 1,
                  child: ShowUpdatePhoto(widget.photoList, verilecekInt),
                );
              },
            ),
          ),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (verilecekInt > 0) {
                    setState(() {
                      verilecekInt--;
                    });
                  }
                  debugPrint(verilecekInt.toString());
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width / 2,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint('----${widget.photoList.length}');
                  if (widget.photoList.length - 1 > verilecekInt) {
                    setState(() {
                      verilecekInt++;
                      debugPrint(verilecekInt.toString());
                    });
                  }
                  whoWillSeeMethod();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width / 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void whoWillSeeMethod() async {
    if (widget.photoList.length == verilecekInt + 1) {
      //widget.snapshot.data!.docs[widget.index][''];
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      List<dynamic> currentArray = data['whoWillSee'];
      currentArray.remove(currentUserEmail);
      FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'whoWillSee': currentArray,
      });
      FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'whoCheck': [currentUserEmail],
      });
    }
  }
}
