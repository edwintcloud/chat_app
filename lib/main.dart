//===================================================================
// File: main.dart
//
// Desc: Main entry point for application.
//
// Copyright © 2019 Edwin Cloud. All rights reserved.
//
// * Attribution to Tensor and his channel on YouTube at      *
// * https://www.youtube.com/channel/UCYqCZOwHbnPwyjawKfE21wg *
//===================================================================

//-------------------------------------------------------------------
// Imports
//-------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

//-------------------------------------------------------------------
// Global Constants
//-------------------------------------------------------------------
const String defaultUserName = "John Doe";

//-------------------------------------------------------------------
// Global Variables/Instances
//-------------------------------------------------------------------

// iOS theme
final ThemeData iOSTheme = ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey,
  primaryColorBrightness: Brightness.dark,
);

// android theme
final ThemeData androidTheme = ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

//-------------------------------------------------------------------
// Main Entrypoint
//-------------------------------------------------------------------
void main() => runApp(MyApp());

//-------------------------------------------------------------------
// MyApp (Class) - StatelessWidget
//-------------------------------------------------------------------
class MyApp extends StatelessWidget {
  // build App
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iOSTheme : androidTheme,
      home: new Chat(),
    );
  }
}

//-------------------------------------------------------------------
// Chat (Class) - StatefulWidget
//-------------------------------------------------------------------
class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChatWindow();
  }
}

//-------------------------------------------------------------------
// ChatWindow (Class) - State<Chat>
//-------------------------------------------------------------------
class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  // class variables (State)
  final List<Message> _messages = <Message>[]; // create empty list of Message
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  // build chat window
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
              reverse: true,
              padding: EdgeInsets.all(6.0),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            child: _buildComposer(),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
          )
        ],
      ),
    );
  }

  // build compose field at bottom of window
  Widget _buildComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 9.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = txt.length > 0;
                  });
                },
                onSubmitted: _submitMessage,
                decoration: InputDecoration.collapsed(
                  hintText: "Enter some text to send a message",
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 3.0,
                ),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Submit"),
                        onPressed: _isWriting
                            ? () => _submitMessage(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.message),
                        onPressed: _isWriting
                            ? () => _submitMessage(_textController.text)
                            : null,
                      ))
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.brown,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  // submit message handler
  void _submitMessage(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Message message = Message(
      txt: txt,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 800,
        ),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  // destructor
  @override
  void dispose() {
    for (Message message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

//-------------------------------------------------------------------
// Message (Class) - StatelessWidget
//-------------------------------------------------------------------
class Message extends StatelessWidget {
  // constructor
  Message({
    this.txt,
    this.animationController,
  });

  // class variables
  final String txt;
  final AnimationController animationController;

  // build message
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              child: CircleAvatar(
                child: Text(
                  defaultUserName[0],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    defaultUserName,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 6.0,
                    ),
                    child: Text(
                      txt,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
