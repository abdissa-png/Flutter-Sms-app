import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms_app/message.dart';
import 'createMessage.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    getAllSms();
  }

  Future<void> getAllSms() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      List<SmsMessage> messages = await SmsQuery().getAllSms;
      print(messages[0].body);
      setState(() {
        _messages = messages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Messages",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateMessage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black12,
              backgroundImage: AssetImage("assets/images/user.jpg"),
              radius: 20,
            ),
            title: Text(_messages[index].sender!),
            subtitle: Text(_messages[index].body!, maxLines: 2),
            onTap: () async {
              // List<SmsMessage> sentMessages = await SmsQuery().querySms(
              //   address: _messages[index].sender,
              //   kinds: [SmsQueryKind.sent],
              // );
              // final receivedMessages =
              //     await SmsQuery().querySms(address: _messages[index].sender!);
              // for (var message in receivedMessages) {
              //   print(message.sender);
              //   print(message.body);
              // }
              // for (var message in sentMessages) {
              //   print(message.sender);
              //   print(message.body);
              // }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageScreen(
                            PhoneNumber: _messages[index].sender,
                          )));
            },
            trailing: Column(
              children: [
                Text("${DateFormat('E MMM y').format(_messages[index].date!)}",
                    style: TextStyle(fontSize: 11.0)),
                Text("${DateFormat('h:mm a').format(_messages[index].date!)}",
                    style: TextStyle(fontSize: 11.0)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
