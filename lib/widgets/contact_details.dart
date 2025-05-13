import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ft_hangout/providers/localizations.dart';
import '../data/models/contact.dart';
import '../data/repositories/contact.dart';
import '../data/repositories/phone.dart';
import 'conversation_sms.dart';
import 'create_contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;

  const ContactDetails({required this.contact, super.key});

  Future<void> deleteContact(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(context.getText('delconta')),
            content: Text(context.getText('confdelc')),
            actions: [
              TextButton(
                child: Text(context.getText('cancel')),
                onPressed: () => Navigator.pop(ctx, false),
              ),
              TextButton(
                child: Text(context.getText('delete')),
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      await ContactRepo.instance.deleteContact(contact.id!);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> callContact(String number, BuildContext context) async {
    try {
      print("la");
      await PhoneRepo.callNumber(contact.phoneNumber);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.getText('call_error'))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.getText('detacont')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateContact(contact: contact),
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteContact(context),
          ),
          IconButton(
            icon: const Icon(Icons.sms),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationSms(contact: contact),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 44,
                  child: Text(
                    contact.firstName.isNotEmpty
                        ? contact.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${contact.firstName} ${contact.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ListTile(
                onTap: () {
                  contact.phoneNumber.isNotEmpty
                      ? callContact(contact.phoneNumber, context)
                      : null;
                },
                leading: const Icon(Icons.phone),
                title: Text(contact.phoneNumber),
              ),

              ListTile(
                leading: const Icon(Icons.email),
                title: Text(contact.email),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(contact.address),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
