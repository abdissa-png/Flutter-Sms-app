import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessageScreen extends StatefulWidget {
  String? PhoneNumber;
  MessageScreen({super.key, this.PhoneNumber});

  @override
  State<MessageScreen> createState() =>
      _MessageScreenState(PhoneNumber: PhoneNumber);
}

class _MessageScreenState extends State<MessageScreen> {
  List<SmsMessage> _messages = [];
  List<SmsMessage> _receiverMessages = [];
  List<SmsMessage> _senderMessages = [];

  @override
  void initState() {
    super.initState();
    getAllSms();
  }

  Future<void> getAllSms() async {
    List<SmsMessage> messages = [];
    List<SmsMessage> receiverMessages = [];
    List<SmsMessage> senderMessages = [];
    List<SmsMessage> sentMessages = await SmsQuery().querySms(
      address: PhoneNumber,
      kinds: [SmsQueryKind.sent],
    );
    final receivedMessages = await SmsQuery().querySms(address: PhoneNumber);
    for (var message in receivedMessages) {
      messages.add(message);
      receiverMessages.add(message);
    }
    for (var message in sentMessages) {
      messages.add(message);
      senderMessages.add(message);
    }
    _senderMessages = senderMessages;
    _receiverMessages = receiverMessages;
    messages.sort((a, b) => a.date!.compareTo(b.date!));
    setState(() {
      _messages = messages;
    });
  }

  String? PhoneNumber;
  TextEditingController _message = TextEditingController();
  _MessageScreenState({this.PhoneNumber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            PhoneNumber!,
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isMe = false;
                  if (_senderMessages.contains(_messages[index])) {
                    isMe = true;
                  }
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.grey[300] : Colors.blue[400],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: isMe
                                  ? Radius.circular(20)
                                  : Radius.circular(0),
                              bottomRight: isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(20),
                            ),
                          ),
                          child: SizedBox(
                            width: 200.0,
                            child: Text(
                              maxLines: null,
                              '${_messages[index].body}',
                              style: TextStyle(
                                  color: isMe ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
                    controller: _message,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Message',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Color(0x7FFFFFFF),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(14, 16, 24, 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendSMS(
                          sendDirect: true,
                          message: _message.text,
                          recipients: [PhoneNumber!]).catchError((onError) {
                        print(onError);
                        return Future.error(onError);
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Message is sent"),
                          duration: Duration(seconds: 1),
                        ));
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(Icons.send))
              ],
            )
          ],
        ));
  }
}
