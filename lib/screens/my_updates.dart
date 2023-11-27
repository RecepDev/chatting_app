import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyUpdatesScreen extends StatefulWidget {
  const MyUpdatesScreen({super.key, required this.list});
  final List<dynamic> list;
  @override
  State<MyUpdatesScreen> createState() => _MyUpdatesScreenState();
}

class _MyUpdatesScreenState extends State<MyUpdatesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getList();
  }

  String? user;
  late List urls = [];
  late List<dynamic> lastUrls = [];
  late ListResult listresults;

  @override
  Widget build(BuildContext context) {
    //user = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          titleSpacing: 1,
          leadingWidth: 50,
          automaticallyImplyLeading: false,
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
            'My Status',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  horizontalTitleGap: 12,
                  contentPadding: const EdgeInsets.only(left: 12, right: 12),
                  onTap: () {},
                  leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(widget.list[index])),
                  title: const Text(
                    '0 views',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  subtitle: const Text(
                    'Just now',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: PopupMenuButton(
                      shadowColor: Colors.grey.shade600,
                      icon: const Icon(Icons.more_vert,
                          color: Colors.black), // add this line
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                              padding: const EdgeInsets.all(1),
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Forward',
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
                                  'Share...',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              padding: const EdgeInsets.all(1),
                              onTap: () {
                                Reference ref = FirebaseStorage.instance.ref(
                                    '/${listresults.items[index].fullPath}');

                                ref.delete().then((value) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    setState(() {
                                      widget.list.remove(widget.list[index]);
                                    });
                                  });
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
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
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 15),
                  child: Icon(
                    Icons.lock,
                    size: 19,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Your status updates are ',
                          style: const TextStyle(
                              fontSize: 13,
                              color:
                                  Colors.black), // Use the default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: 'end-to-end encrypted.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            const TextSpan(
                                text: ' They will',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                          ],
                        ),
                      ),
                      const Text(
                        'disappear after 24 hours.',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  void getList() async {
    user = FirebaseAuth.instance.currentUser!.uid;

    FirebaseStorage.instance.ref('/update_images/$user').listAll().then(
      (value) {
        listresults = value;
        // print(listresults.items);
      },
    );

    /* debugPrint('getmyupdates çalişti');
    Future.delayed(const Duration(seconds: 0), () async {
      for (Reference ref in listresult!.items) {
        String downloadURL = await ref.getDownloadURL();
        urls.add(downloadURL);
        debugPrint(urls.toString());

        /* await FirebaseFirestore.instance
          .collection('updates')
          .doc(snapshot.data!.docs[index]['UserUid'])
          .set({
        'userUid': snapshot.data!.docs[index]['UserUid'],
        'userEmail': snapshot.data!.docs[index]['email'],
        'photos': urlsForStart,
      }).then((value) {
        urlsForStart = [];
      }); */
      }
    });
    */
  }
}
