import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_chat/models/chat_user.dart';

class APIs {
  // for firebase auhtentication
  static FirebaseAuth fireauth = FirebaseAuth.instance;

  // to return current user details
  static User get user => fireauth.currentUser!;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to check if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(fireauth.currentUser!.uid)
            .get())
        .exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        image: user.photoURL.toString(),
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
}
