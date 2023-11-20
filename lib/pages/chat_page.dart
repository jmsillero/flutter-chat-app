// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_app/components/chat_message.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<ChatMessage> _messages = <ChatMessage>[];
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    _listenMessage();
    _loadChatHistory(chatService.target.uid);
  }

  void _listenMessage() {
    socketService.socket.on('private-message', (data) {
      final messageItem = ChatMessage(
        message: data['message'],
        from: data['from'],
        to: data['to'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)),
      );

      setState(() {
        _messages.insert(0, messageItem);
        messageItem.animationController.forward();
      });
    });
  }

  void _loadChatHistory(String userId) async {
    List<Message> messages = await chatService.fetchChat(userId);
    _messages = [
      ...messages.map((message) => ChatMessage(
          message: message.message,
          from: message.from,
          to: message.to,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 200))
            ..forward()))
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              CircleAvatar(
                maxRadius: 12,
                child: Text(
                  chatService.target.name.substring(0, 2),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                chatService.target.name,
                style: const TextStyle(fontSize: 10),
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
                          from: authService.user!.uid,
                          to: chatService.target.uid,
                          animationController: animationController,
                        ));

                    _messages[0].animationController.forward();
                  });

                  socketService.socket.emit('private-message', {
                    'from': authService.user!.uid,
                    'to': chatService.target.uid,
                    'message': message
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

    socketService.socket.off('private-message');
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
                    onPressed: isTyping
                        ? () => _handelSubmit(chatBoxController.text)
                        : null,
                    child: const Text('Send'))
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
