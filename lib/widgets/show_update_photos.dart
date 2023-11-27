import 'package:flutter/material.dart';

class ShowUpdatePhoto extends StatefulWidget {
  const ShowUpdatePhoto(this.list, this.intGelen, {super.key});

  final List<dynamic> list;
  final int intGelen;
  @override
  State<ShowUpdatePhoto> createState() => _ShowUpdatePhotoState();
}

class _ShowUpdatePhotoState extends State<ShowUpdatePhoto> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 55,
        child: Image.network(
          '${widget.list[widget.intGelen]}',
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
        ));
  }
}
