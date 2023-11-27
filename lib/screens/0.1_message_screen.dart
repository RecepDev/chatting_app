import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/screens/-home_page.dart';
import 'package:chatting_app/screens/0.111_chat_detail_screen.dart';
import 'package:chatting_app/widgets/chat_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:chatting_app/widgets/group_messages.dart';
import 'package:chatting_app/widgets/new_messages.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    super.key,
    required this.title,
    required this.mail,
    required this.sendedId,
    required this.gonderilecekChatName,
    required this.isGroup,
    required this.userList,
    required this.gelenAvatar,
    required this.groupNumber,
    required this.creatorName,
    required this.createdAt,
    required this.docID,
    required this.creatorEmail,
    required this.owners,
    required this.toEmail,
  });

  final bool isGroup;
  final String title;
  final String creatorName;
  final String mail;
  final String creatorEmail;
  final List<dynamic> owners;
  final String toEmail;

  final int groupNumber;
  final String createdAt;
  final String docID;
  final String sendedId;
  final CircleAvatar gelenAvatar;
  final String gonderilecekChatName;
  final List<ZegoUIKitUser> userList;
  //userList.add(ZegoUIKitUser

  @override
  State<MessagesScreen> createState() => MessagesScreenState();
}

String? currentUserEmail;
String? userUid;
ZegoSendCallInvitationButton? actionButton;

class MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<CallerIdNotifier>(context, listen: false)
            .changeImagePadding(MediaQuery.sizeOf(context).width / 2 - 92);
      },
    );

    currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    userUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leadingWidth: 82,
        titleSpacing: 2,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const HomePage(),
                  type: PageTransitionType.leftToRight,
                  duration: const Duration(milliseconds: 200),
                ),
              );
            },
            child: Row(
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                Hero(
                  tag: 'tag1',
                  child: SizedBox(
                    height: 39,
                    width: 39,
                    child: FittedBox(
                      child: widget.gelenAvatar,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                creatorEmail: widget.creatorEmail,
                owners: widget.owners,
                toEmail: widget.toEmail,
                docID: widget.docID,
                createdAt: widget.createdAt,
                creatoreName: widget.creatorName,
                groupNumber: widget.groupNumber,
                isGroup: widget.isGroup,
                userMail: widget.mail,
                gelenAvatar: widget.gelenAvatar, //
                chatName: widget.title,
                voiceCall: actionButton(false, widget.userList,
                    Theme.of(context).colorScheme.primary, 33, widget.isGroup),
                videoCall: actionButton(true, widget.userList,
                    Theme.of(context).colorScheme.primary, 33, widget.isGroup),
              ),
            ));
          },
          title: Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: actionButton(
                false, widget.userList, Colors.white, 24, widget.isGroup),
          ),
          IconButton(
            onPressed: () {},
            icon: actionButton(
                true, widget.userList, Colors.white, 24, widget.isGroup),
          ),
          PopupMenuButton(
              shadowColor: Colors.white,
              icon: const Icon(Icons.more_vert,
                  color: Colors.white), // add this line
              itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      padding: const EdgeInsets.all(1),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Group info',
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
                          'Group media',
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
                          'Search',
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
                          'Mute notification',
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
                          'disappering massages',
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
                          'Wallpaper',
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
                          'More',
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
              }),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              widget.isGroup
                  ? Expanded(
                      child: GroupMessage(
                        messageId: widget.sendedId,
                      ),
                    )
                  : Expanded(child: ChatMessage(messageId: widget.sendedId)),
              NewMessage(
                  gelenId: widget.sendedId,
                  gelenChatName: widget.gonderilecekChatName),
            ],
          )
        ],
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are You Sure?',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                ZegoUIKitPrebuiltCallInvitationService().uninit();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ZegoSendCallInvitationButton actionButton(
      bool isVideo,
      List<ZegoUIKitUser> userList,
      Color color,
      double gelensize,
      bool isGroup) {
    debugPrint(
        '-----------------------------------------$isGroup------------------------------');
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (isGroup) {
          Provider.of<CallerIdNotifier>(context, listen: false)
              .changeDocId(widget.docID);
          Provider.of<CallerIdNotifier>(context, listen: false)
              .changeIsGroup(true);
        } else {
          Provider.of<CallerIdNotifier>(context, listen: false)
              .changeIsGroup(false);
        }
      },
    );

    return ZegoSendCallInvitationButton(
        buttonSize: const Size(40, 40),
        iconSize: const Size(40, 40),
        customData: isGroup ? widget.docID : 'false',
        icon: isVideo
            ? ButtonIcon(
                icon: Icon(
                Icons.video_call,
                color: color,
                size: gelensize,
              ))
            : ButtonIcon(
                icon: Icon(
                Icons.call,
                color: color,
                size: gelensize,
              )),
        resourceID: 'aaabbb',
        invitees: userList,
        isVideoCall: isVideo);
  }
}
