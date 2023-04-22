import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/models/chat_user.dart';
import 'package:in_chat/screens/profile_screen.dart';
import 'package:in_chat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];

  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.selfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
          } else {
            return Future.value(true);
          }
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Name or Email',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 17, letterSpacing: .5),
                    // according to search text update search list
                    onChanged: (value) {
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                : const Text('In Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    _searchList.clear();
                  });
                },
                icon: Icon(
                    _isSearching ? CupertinoIcons.clear_circled : Icons.search),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.self)));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {},
              child: const Icon(Icons.add_comment),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getUsers(),
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
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: const EdgeInsets.only(top: 8),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          // return Text('Name: ${_list[index]}');
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
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
        ),
      ),
    );
  }
}
