import 'package:flutter/material.dart';
import 'package:ft_hangout/providers/localizations.dart';
import '../data/models/contact.dart';
import '../data/models/sms.dart';
import '../data/repositories/sms.dart';

class ConversationSms extends StatefulWidget {
  final Contact contact;
  const ConversationSms({required this.contact, super.key});

  @override
  State<ConversationSms> createState() => _ConversationSmsState();
}

class _ConversationSmsState extends State<ConversationSms> {
  final TextEditingController _messageCtrl = TextEditingController();
  List<Sms> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final allMessages = await SmsRepo.getAllSms();
    messages =
        allMessages
            .where(
              (sms) =>
                  sms.senderNum == widget.contact.phoneNumber ||
                  sms.senderNum == 'Moi',
            ) // "Moi" utilisé pour envoyer sms
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)); // ordre chronologique
    if (mounted) setState(() {});
  }

  Future<void> sendSms() async {
    final content = _messageCtrl.text.trim();
    if (content.isEmpty) return;

    await SmsRepo.sendSms(widget.contact.phoneNumber, content);
    _messageCtrl.clear();
    await loadMessages();
  }

  Widget buildMessageBubble(Sms sms) {
    final sentByMe = sms.senderNum != widget.contact.phoneNumber;
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: sentByMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          sms.content,
          style: TextStyle(color: sentByMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${context.getText('convsms')} ${widget.contact.firstName}',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadMessages),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? Center(child: Text(context.getText('nosmsfound')))
                    : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final sms = messages[index];
                        return buildMessageBubble(sms);
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageCtrl,
                    decoration: InputDecoration(
                      hintText: context.getText('entermsg'),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: sendSms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
