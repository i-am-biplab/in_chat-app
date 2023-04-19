import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/models/chat_user.dart';
import 'package:in_chat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('In Chat'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.fireauth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_comment),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show them
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: list.length,
                    padding: const EdgeInsets.only(top: 8),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      // return Text('Name: ${list[index]}');
                      return ChatUserCard(user: list[index]);
                    }),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Connection Found',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          }),
    );
  }
}
