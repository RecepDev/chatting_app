import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class GroupImagePicker extends StatefulWidget {
  const GroupImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<GroupImagePicker> createState() {
    return _GroupImagePickerState();
  }
}

class _GroupImagePickerState extends State<GroupImagePicker> {
  File? _pickedImageFile;
  bool isImagePicked = false;
  late Image defImage = Image.asset('assets/images/group.jpeg');

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
      isImagePicked = true;
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              foregroundImage:
                  //defImage()
                  isImagePicked == true
                      ? FileImage(_pickedImageFile!)
                      : defImage.image,
              //_pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
            ),
          ),
        ),
      ],
    );
  }
}
