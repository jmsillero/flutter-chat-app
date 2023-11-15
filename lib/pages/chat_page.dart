// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/components/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Column(
        children: [
          CircleAvatar(
            maxRadius: 12,
            child: Text(
              'Jm',
              style: TextStyle(fontSize: 10),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'Juan Miguel',
            style: TextStyle(fontSize: 10),
          )
        ],
      )),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _messages[index];
              },
              itemCount: _messages.length,
              reverse: true,
            )),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              //height: 100,
              child: _ChatBox(
                onMessageCallback: (message) {
                  setState(() {
                    final animationController = AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 200));
                    _messages.insert(
                        0,
                        ChatMessage(
                          message: message,
                          uuid: '123',
                          animationController: animationController,
                        ));

                    _messages[0].animationController.forward();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    //Todo: Off Sockets...

    for (var msg in _messages) {
      msg.animationController.dispose();
    }
  }
}

typedef OnMessageCallback = Function(String message);

class _ChatBox extends StatefulWidget {
  final OnMessageCallback onMessageCallback;
  const _ChatBox({
    Key? key,
    required this.onMessageCallback,
  }) : super(key: key);

  @override
  State<_ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<_ChatBox> {
  final chatBoxController = TextEditingController();
  final focusNode = FocusNode();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: chatBoxController,
            onSubmitted: _handelSubmit,
            onChanged: (value) {
              setState(() {
                isTyping = value.trim().isNotEmpty;
              });
            },
            focusNode: focusNode,
            decoration:
                const InputDecoration.collapsed(hintText: 'Send message'),
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Send'),
                    onPressed: isTyping
                        ? () => _handelSubmit(chatBoxController.text)
                        : null)
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: isTyping
                            ? () => _handelSubmit(chatBoxController.text)
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handelSubmit(String text) {
    if (text.isEmpty) return;
    focusNode.requestFocus();
    chatBoxController.clear();
    widget.onMessageCallback(text);
    setState(() {
      isTyping = false;
    });
  }
}
