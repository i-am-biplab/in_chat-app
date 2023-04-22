import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:in_chat/models/chat_user.dart';

class APIs {
  // for firebase auhtentication
  static FirebaseAuth fireauth = FirebaseAuth.instance;

  // to return current user details
  static User get user => fireauth.currentUser!;

  // to return current userinfo details
  static UserInfo get userInfo => user.providerData[0];

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage fstorage = FirebaseStorage.instance;

  static late ChatUser self;

  // to check if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // to get current user self info
  static Future<void> selfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        self = ChatUser.fromJson(user.data()!);
        // log('User Self Data: $self');
        log('User Self Data: ${user.data()}');
      } else {
        await createUser().then((value) => selfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        image: userInfo.photoURL.toString(),
        about: 'Hey There! I am using In Chat',
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        email: user.email.toString(),
        pushToken: "");
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  // for getting all users from firestore except the logged in one
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // to update user details
  static Future<void> updateUserDetl() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': self.name,
      'about': self.about,
    });
  }

  // update profile picture of the user
  static Future<void> updateProfilePic(File file) async {
    // taking out image file extension
    final ext = file.path.split('.').last;
    log('Image extension: $ext');

    // storing ref with path
    final ref = fstorage.ref().child('profle_pics/${user.uid}.$ext');

    // upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kB');
    });

    // update image url in firestore
    self.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': self.image,
    });
  }
}
