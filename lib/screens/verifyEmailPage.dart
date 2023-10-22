import 'dart:async';

import 'package:chatting_app/screens/auth.dart';
import 'package:chatting_app/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailpage extends StatefulWidget {
  const VerifyEmailpage({super.key});

  @override
  State<VerifyEmailpage> createState() => _VerifyEmailpageState();
}

class _VerifyEmailpageState extends State<VerifyEmailpage> {
  bool isEmailverified = false;
  Timer? timer;
   Timer? _timerr;
   int _start = 60;
  bool canResendEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isEmailverified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailverified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    _timerr?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailverified = FirebaseAuth.instance.currentUser!.emailVerified;

      if (isEmailverified) timer?.cancel();
    });
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      startTimer();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      setState(() => canResendEmail = true);
      print('$e');
    }
  }
  void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timerr =  Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _start =60;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}
  @override
  Widget build(BuildContext context) => isEmailverified
      ? const ChatScreen()
      : Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(onPressed: (){
                FirebaseAuth.instance.signOut();
              }, icon: Icon(Icons.backup))
            ],
            title: Text(' '),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text(
                    'A verification email has been sent to your email.',
                    style: TextStyle(fontSize: 22),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.email),
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    label: const Text(
                      'Resent Email',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Text('You can resent email after $_start seconds'),
                ],
              ),
            ),
          ),
        );
}
