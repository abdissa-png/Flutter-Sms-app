import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'homepage.dart';

class CreateMessage extends StatefulWidget {
  const CreateMessage({Key? key}) : super(key: key);

  @override
  State<CreateMessage> createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {
  TextEditingController _phoneNumbers = TextEditingController();
  TextEditingController _message = TextEditingController();
  final Map<String, dynamic> receivers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Write Message",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      controller: _phoneNumbers,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0x00000000),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
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
                      onPressed: () async {
                        final PhoneContact contact =
                            await FlutterContactPicker.pickPhoneContact();
                        final number = contact.phoneNumber?.number;
                        final name = contact.fullName;
                        if (number != Null) {
                          // print(contact.phoneNumber?.number);
                          receivers[number!] = name;
                          setState(() {
                            _phoneNumbers.text = "";
                            for (var key in receivers.keys) {
                              _phoneNumbers.text +=
                                  "${receivers[key]}:   $key\n";
                            }
                          });
                        }
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              SizedBox(
                height: 500,
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
                            color: Color(0x00000000),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
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
                                recipients: receivers.keys.toList())
                            .catchError((onError) {
                          return Future.error(onError.toString());
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
          ),
        ),
      ),
    );
  }
}
