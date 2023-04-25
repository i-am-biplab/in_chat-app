import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/helper/my_date_util.dart';
import 'package:in_chat/main.dart';
import 'package:in_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromID
        ? _myMessage()
        : _recipientMessage();
  }

  // recipient message
  Widget _recipientMessage() {
    // update last read message if sender and receiver is different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('Message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.only(
                left: mq.width * .04,
                top: mq.height * .005,
                bottom: mq.height * .005,
                right: mq.width * .02),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 244, 213),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                border: Border.all(color: Colors.amber)),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Text(
          MyDateUtil.getFormattedTime(
              context: context, time: widget.message.sent),
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        SizedBox(
          width: mq.width * .25,
        ),
      ],
    );
  }

  // sender message
  Widget _myMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: mq.width * .25,
        ),
        Row(
          children: [
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            // for adding some space in b/w
            const SizedBox(
              width: 4,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              )
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.only(
                left: mq.width * .02,
                top: mq.height * .005,
                bottom: mq.height * .005,
                right: mq.width * .04),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 227, 246),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                border: Border.all(color: Colors.indigoAccent)),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
