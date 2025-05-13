import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ft_hangout/providers/background.dart';
import 'package:ft_hangout/providers/color.dart';
import 'package:ft_hangout/providers/localizations.dart';
import '../data/models/contact.dart';
import '../data/repositories/contact.dart';
import '../data/repositories/localization.dart';
import '../data/repositories/sms.dart';
import 'color_dialog.dart';
import 'contact_details.dart';
import 'create_contact.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    refreshContacts();
  }

  Future<void> refreshContacts() async {
    await analyseNewSmsForAutoContact();

    contacts = await ContactRepo.instance.getAllContacts();
    setState(() {});
  }

  Future<void> analyseNewSmsForAutoContact() async {
    final smsNumList = await SmsRepo.getAllSms().then(
      (list) => list.map((sms) => sms.senderNum).toSet(),
    );
    final contacts = await ContactRepo.instance.getAllContacts();
    final db = await ContactRepo.instance.database;
    final deletedNumbersRaw = await db.query('deleted_numbers');
    final Set<String> deletedNumbers =
        deletedNumbersRaw.map((e) => e['phoneNumber'] as String).toSet();

    for (final num in smsNumList) {
      final notInContacts = !contacts.any((c) => c.phoneNumber == num);
      final notDeleted = !deletedNumbers.contains(num);
      if (notInContacts && notDeleted) {
        await ContactRepo.instance.createContact(
          Contact(
            firstName: num,
            lastName: '',
            phoneNumber: num,
            email: '',
            address: '',
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final backgroundProvider = context.background;

    if (state == AppLifecycleState.paused) {
      backgroundProvider.setBackgroundDate(DateTime.now());
    }
    if (state == AppLifecycleState.resumed &&
        backgroundProvider.lastBackgroundDate != null) {
      final dt = backgroundProvider.lastBackgroundDate!;
      final text = '${context.getText('lastbg')}: ${dt.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
      refreshContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.localization;
    final currentColor = context.color.appBarColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentColor,

        title: Text(context.getText('a0s9d8f7')),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String lang) => localization.setLanguage(lang),
            itemBuilder:
                (_) =>
                    LocalizationRepo.languages
                        .map(
                          (lang) => PopupMenuItem<String>(
                            value: lang,
                            child: Text(lang.toUpperCase()),
                          ),
                        )
                        .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (_) => const ColorDialog(),
                ),
          ),
        ],
      ),
      body:
          contacts.isEmpty
              ? Center(child: Text(context.getText('vgy7r5x2')))
              : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    title: Text('${contact.firstName} ${contact.lastName}'),
                    subtitle: Text(contact.phoneNumber),
                    leading: CircleAvatar(
                      child: Text(contact.firstName[0].toUpperCase()),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactDetails(contact: contact),
                        ),
                      );
                      refreshContacts();
                    },
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateContact()),
          );
          refreshContacts();
        },
      ),
    );
  }
}
