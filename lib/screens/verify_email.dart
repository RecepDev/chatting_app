import 'dart:async';
import 'dart:math';

import 'package:chatting_app/model/user_callId_provider.dart';
import 'package:chatting_app/screens/auth.dart';
import 'package:chatting_app/screens/-home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
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
      await Future.delayed(const Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      setState(() => canResendEmail = true);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timerr = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 60;
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
  Widget build(BuildContext context) {
    if (isEmailverified) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Provider.of<CallerIdNotifier>(context, listen: false)
              .updateUserInformation();
        },
      );

      return const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  ZegoUIKitPrebuiltCallInvitationService().uninit();
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.backup))
          ],
          title: const Text(' '),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email.',
                  style: TextStyle(fontSize: 22),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.email),
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
  }
}
