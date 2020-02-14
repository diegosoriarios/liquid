import 'package:liquid/models/chat_message.dart';
import 'package:liquid/widgets/chat_message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("ChatBot - Eu")
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  void _sendMessage({ String text }) {
    _controllerText.clear();
    _addMessage(name: 'Diego Soria Rios', text: text, type: ChatMessageType.sent);
  }

  void _addMessage({ String name, String text, ChatMessageType type }) {
    var message = ChatMessage(
      text: text, name: name, type: type, hour: DateTime.now()
    );

    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      _dialogFlowRequest(query: message.text);
    }
  }

  Future _dialogFlowRequest({ String query }) async {
    _addMessage(
      name: 'Diego Soria Rios',
      text: 'Escrevendo...',
      type: ChatMessageType.received
    );

    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credential.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    setState(() {
      _messageList.removeAt(0);
    });

    _addMessage(
      name: 'Diego Soria Rios',
      text: response.getMessage() ?? '',
      type: ChatMessageType.received
    );
  }

  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: _controllerText,
        decoration: new InputDecoration.collapsed(hintText: "Enviar Mensagem"),
      )
    );
  }

  Widget _buildSentButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
        icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
        onPressed: () {
          if (_controllerText.text.isNotEmpty) {
            _sendMessage(text: _controllerText.text);
          }
        },
      ),
    );
  }

  Widget _buildUserInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSentButton()
        ],
      )
    );
  }
}