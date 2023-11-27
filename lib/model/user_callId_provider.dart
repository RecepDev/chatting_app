import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CallerIdNotifier extends ChangeNotifier {
  int _selectedTabIndexProvider = 0;
  String _callerType = '';
  final List<String> _callerNames = [];
  final List<String> _callerIds = [];
  int _callerId = 0;
  int _contact = 0;
  String _docId = '';
  bool _isGroup = false;
  List<Map<String, dynamic>> _userList = [];
  bool _dropDownPressed = false;
  bool _isCallService = true;

  User? _user;
  double _controller = 250;
  double _imageWidth = 125;
  double _imageHeight = 125;
  bool _isVisible = false;
  double _imageLeftPadding = 0;

  String get getcallerType => _callerType;
  List<String> get getcallerNames => _callerNames;
  List<String> get getcallerIds => _callerIds;
  int get getcallerId => _callerId;
  int get getcontact => _contact;
  bool get getisGroup => _isGroup;
  String get getdocId => _docId;
  int get getselectedTabIndexProvider => _selectedTabIndexProvider;
  List<Map<String, dynamic>> get getuserList => _userList;
  bool get getDropDown => _dropDownPressed;

  User? get getmyuser => _user;

  bool get getisCallService => _isCallService;
  bool get getisVisible => _isVisible;
  double get getcontroller => _controller;
  double get getimageWidth => _imageWidth;
  double get getimageHeight => _imageHeight;
  double get getimageLeftPadding => _imageLeftPadding;

  void changeCallerType(String type) {
    _callerType = type;
    notifyListeners();
  }

  updateUserInformation() {
    debugPrint('----------------------USER UPDATED-----------------');
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      //   print(firebaseUser.uid);
      _user = firebaseUser;

      notifyListeners();
    }
  }

  void changeBool(bool gelenbool) {
    _isCallService = gelenbool;
    notifyListeners();
  }

  void changeBoolIsVisible(bool gelenbool) {
    _isVisible = gelenbool;
    notifyListeners();
  }

  void changeTabindex(int int) {
    _selectedTabIndexProvider = int;
    notifyListeners();
  }

  void changeUserList(List<Map<String, dynamic>> gelenlist) {
    _userList = gelenlist;
    notifyListeners();
  }

  void changeDropDownBool(bool type) {
    _dropDownPressed = type;
    notifyListeners();
  }

  void changeImagePadding(double gelendouble) {
    _controller = gelendouble;

    notifyListeners();
  }

  void changeImagePadding2(double gelendouble) {
    _imageLeftPadding = gelendouble;

    notifyListeners();
  }

  void addCallerNames(String gelencallerNames) {
    _callerNames.add(gelencallerNames);

    notifyListeners();
  }

  void removeCallerNames(String gelencallerNames) {
    _callerNames.remove(gelencallerNames);

    notifyListeners();
  }

  void addCallerIds(String gelenCallerIds) {
    _callerIds.add(gelenCallerIds);

    notifyListeners();
  }

  void changeContactslength(int gelenint) {
    _contact = gelenint;

    notifyListeners();
  }

  void removeCallerIds(String gelenCallerIds) {
    _callerIds.remove(gelenCallerIds);

    notifyListeners();
  }

  void changeCallerId(int gelencallerIds) {
    _callerId = gelencallerIds;
    notifyListeners();
  }

  void changeIsGroup(bool gelenisGroup) {
    _isGroup = gelenisGroup;
    notifyListeners();
  }

  void changeDocId(String gelendocId) {
    _docId = gelendocId;
    notifyListeners();
  }

  void changeImageWidth(double gelendouble) {
    _imageWidth = gelendouble;
    // print(gelendouble);
    notifyListeners();
  }

  void changeImageHeight(double gelendouble) {
    _imageHeight = gelendouble;
    // print(gelendouble);
    notifyListeners();
  }
}
