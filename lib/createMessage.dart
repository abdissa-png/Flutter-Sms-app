import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Write Message",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 26.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          )),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Wrap(
                        spacing: 8.0,
                        children: receivers.keys.map((number) {
                          return InputChip(
                            label: Text('${receivers[number]}'),
                            onDeleted: () {
                              setState(() {
                                receivers.remove(number);
                              });
                            },
                          );
                        }).toList(),
                      ),
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
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color(0x00000000),
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
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
                                    const EdgeInsetsDirectional.fromSTEB(
                                        14, 16, 24, 16),
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
                                    await FlutterContactPicker
                                        .pickPhoneContact();
                                final number = contact.phoneNumber?.number;
                                final name = contact.fullName;
                                if (number != Null) {
                                  setState(() {
                                    receivers[number!] = name;
                                  });
                                }
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),
                    ],
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
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
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
                                const EdgeInsetsDirectional.fromSTEB(
                                    14, 16, 24, 16),
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
                            if (_message.text != '' || receivers != {}) {
                              bool result = false;
                              Set recipients = {};
                              recipients.addAll(receivers.keys.toList());
                              _phoneNumbers.text != ""
                                  ? recipients.add(_phoneNumbers.text)
                                  : null;
                              await sendSMS(
                                      sendDirect: true,
                                      message: _message.text,
                                      recipients: List.from(recipients))
                                  .catchError((onError) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Message is not sent"),
                                  duration: Duration(seconds: 1),
                                ));
                                return Future.error(onError.toString());
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
                            }
                          },
                          icon: const Icon(Icons.send))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
