import 'package:chatting_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

class UserDatabaseProvider {
  // String? userEmail = FirebaseAuth.instance.currentUser!.uid;

  final int _version = 7;
  Database? database;

  String columnEmail = 'email';
  String columnUsername = 'userName';
  String columnImageUrl = 'imageUrl';
  String columnId = 'voiceCallId';

  Future<void> initialize() async {
    final path = await getDatabasesPath();
    database = await openDatabase('$path/users.db', version: _version,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE users (id INTEGER PRIMARY KEY, $columnId INTEGER, $columnUsername TEXT, $columnEmail  TEXT, $columnImageUrl TEXT)');
    });
  }

  void createTable(Database db) {
    String? userUid = FirebaseAuth.instance.currentUser!.uid;
    debugPrint(
        '----------------------------AÇILACAK TABLE $userUid ------------------------');

    db.execute('''
          CREATE TABLE IF NOT EXISTS $userUid (
            id INTEGER PRIMARY KEY,
            $columnId TEXT,
            'callerNames',
            $columnUsername TEXT,
            $columnEmail TEXT,
            $columnImageUrl TEXT,
            isCanceled TEXT,
            message TEXT,
            CancelTime TEXT,
            isIncoming TEXT,
            isTimeout TEXT,
            isVideo TEXT,
            toWhere TEXT,
            info TEXT,
            isGroup,
            docId
          )
        ''');
  }

  void update(Database db) async {
    await db.transaction((txn) async {
      String? userUid = FirebaseAuth.instance.currentUser!.uid;
      await txn.execute('''
          CREATE TABLE $userUid (
            id INTEGER PRIMARY KEY,
            $columnId INTEGER,
            $columnUsername TEXT,
            $columnEmail TEXT,
            $columnImageUrl TEXT,
            isCanceled TEXT,
            message TEXT,
            CancelTime TEXT
          )
        ''');
      // Diğer güncellemeleri burada ekleyebilirsiniz
    });
  }

  Future<List<UserModel>> getList() async {
    if (database == null) {
      await initialize();
    }
    List<Map> userMaps = await database!.query('users');
    return userMaps.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel?> getUser(int voiceCallerId) async {
    if (database == null) {
      await initialize();
    }

    debugPrint(voiceCallerId.toString());
    final usermaps = await database!
        .query('users', where: 'voiceCallId = ?', whereArgs: [voiceCallerId]);

    if (usermaps.isNotEmpty) {
      return UserModel.fromJson(usermaps.first);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers(String myUid) async {
    if (database == null) {
      await initialize();
    }

    final users = await database!.query(myUid);
    if (users.isEmpty) {
      createTable(database!);
    }
    return users;
  }

  Future<void> insert(UserModel model) async {
    if (database == null) {
      await initialize();
    }

    await database!.insert(
      'users',
      model.toJson(),
    );
  }

  Future<void> insertGroup(
    String imageUrl,
    String title,
  ) async {
    if (database == null) {
      await initialize();
    }

    await database!.insert(
      'users',
      {
        'imageUrl': imageUrl,
        'groupName': title,
      },
    );
  }

  Future<void> updateList(Map<String, dynamic> silinenList) async {
    if (database == null) {
      await initialize();
    }
    //if (database != null) open();
    String? userUid = FirebaseAuth.instance.currentUser!.uid;

    database!.delete(
      userUid,
      where: 'id = ?',
      whereArgs: [silinenList['id']],
    );
  }

  Future<void> insertUserForList(
    UserModel model,
    String message,
    String date,
    String isCanceled,
    String isIncoming,
    String isTimeout,
    String isVideo,
    String toWhere,
    String info,
    String isGroup,
  ) async {
    String? userUid = FirebaseAuth.instance.currentUser!.uid;
    initialize().then((value) async {
      await database!.insert(
        userUid,
        {
          columnId: model.voiceCallId,
          columnEmail: model.mail,
          columnImageUrl: model.imageUrl,
          columnUsername: model.userName,
          'message': message,
          'isCanceled': isCanceled,
          'CancelTime': date,
          'isIncoming': isIncoming,
          'isTimeout': isTimeout,
          'isVideo': isVideo,
          'toWhere': toWhere,
          'info': info,
          'isGroup': isGroup,
        },
      );
    });
    //debugPrint('$isVideo + asdwqewq');
  }

  Future<void> insertGroupForList(
    String groupName,
    List<String> callerIds,
    List<String> callerNames,
    String groupImage,
    String message,
    String date,
    String isCanceled,
    String isIncoming,
    String isTimeout,
    String isVideo,
    String toWhere,
    String info,
    String isGroup,
    String docId,
  ) async {
    String? userUid = FirebaseAuth.instance.currentUser!.uid;
    initialize().then((value) async {
      await database!.insert(
        userUid,
        {
          columnId: callerIds.toString(),
          'callerNames': callerNames.toString(),
          columnEmail: 'group descp',
          columnImageUrl: groupImage,
          columnUsername: groupName,
          'message': message,
          'isCanceled': isCanceled,
          'CancelTime': date,
          'isIncoming': isIncoming,
          'isTimeout': isTimeout,
          'isVideo': isVideo,
          'toWhere': toWhere,
          'info': info,
          'isGroup': isGroup,
          'docId': docId,
        },
      );
    });
    //debugPrint('$isVideo + asdwqewq');
  }

  void delete(List<dynamic> voiceCallId) async {
    if (database == null) {
      await initialize();
    }
    for (final id in voiceCallId) {
      await database!
          .delete('users', where: 'voiceCallId = ?', whereArgs: [id]);
    }
  }

  Future<bool> isUserAlreadyExists(String email) async {
    if (database == null) {
      await initialize();
    }
    final result = await database!.query(
      'users', // Tablo adı
      where: 'email = ?', // E-posta adresine göre sorgulama
      whereArgs: [email], // E-posta adresi değeri
    );

    return result.isNotEmpty; // Eğer sonuç boş değilse, kullanıcı mevcuttur.
  }
}
