import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/main.dart';
import 'package:in_chat/models/chat_user.dart';
import 'package:in_chat/models/message.dart';
import 'package:in_chat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages int the list
  List<Message> _list = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // MediaQueryData queryData = MediaQuery.of(context);
    // double navigationBarHeight = queryData.padding.top;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Color.fromARGB(255, 236, 255, 213),
        body: Column(
          children: [
            Expanded(
              child: Container(
                // height: mq.height - navigationBarHeight,
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(child: SizedBox());

                        //if some or all data is loaded then show them
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          // log('Data: ${jsonEncode(data![0].data())}');
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: _list.length,
                              padding: const EdgeInsets.only(top: 8),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return MessageCard(message: _list[index]);
                              }),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hi! 👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    }),
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  // Define appbar content
  Widget _appBar() {
    return SafeArea(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            // back button
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black54,
            ),
            // user profile image
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                imageUrl: widget.user.image,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            // for some space in b/w
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display user name
                Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                // for some space in b/w
                const SizedBox(
                  height: 2,
                ),
                // Dislay user last seen
                const Text(
                  'Last seen not found',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .005, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions),
                    color: Colors.indigo,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _textController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                    color: Colors.indigo,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded),
                    color: Colors.indigo,
                  ),
                  // for some space in b/w
                  const SizedBox(
                    width: 2,
                  ),
                ],
              ),
            ),
          ),

          // send button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            color: Colors.green,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
