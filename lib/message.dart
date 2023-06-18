import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessageScreen extends StatefulWidget {
  final String? phoneNumber;
  const MessageScreen({super.key, this.phoneNumber});

  @override
  State<MessageScreen> createState() =>
      // ignore: no_logic_in_create_state
      _MessageScreenState(PhoneNumber: phoneNumber);
}

class _MessageScreenState extends State<MessageScreen> {
  List<SmsMessage> _messages = [];
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
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            PhoneNumber!,
            style: const TextStyle(
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.grey[300] : Colors.blue[400],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isMe
                                  ? const Radius.circular(20)
                                  : const Radius.circular(0),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
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
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: const Color(0x7FFFFFFF),
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(14, 16, 24, 16),
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
                    onPressed: () async {
                      bool result = false;
                      await sendSMS(
                          sendDirect: true,
                          message: _message.text,
                          recipients: [PhoneNumber!]).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Message is not sent"),
                          duration: Duration(seconds: 1),
                        ));
                        return Future.error(onError);
                      }).then((value) {
                        result = true;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Message is sent"),
                          duration: Duration(seconds: 1),
                        ));
                      });
                      if (result) {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                      }
                    },
                    icon: const Icon(Icons.send))
              ],
            )
          ],
        ));
  }
}
