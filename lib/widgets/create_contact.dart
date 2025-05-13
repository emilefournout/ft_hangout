import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ft_hangout/providers/localizations.dart';
import '../data/models/contact.dart';
import '../data/repositories/contact.dart';

class CreateContact extends StatefulWidget {
  final Contact? contact;
  const CreateContact({super.key, this.contact});

  @override
  State<CreateContact> createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    firstNameCtrl = TextEditingController(text: contact?.firstName ?? '');
    lastNameCtrl = TextEditingController(text: contact?.lastName ?? '');
    phoneCtrl = TextEditingController(text: contact?.phoneNumber ?? '');
    emailCtrl = TextEditingController(text: contact?.email ?? '');
    addressCtrl = TextEditingController(text: contact?.address ?? '');
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> saveContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id,
        firstName: firstNameCtrl.text,
        lastName: lastNameCtrl.text,
        phoneNumber: phoneCtrl.text,
        email: emailCtrl.text,
        address: addressCtrl.text,
      );
      if (widget.contact == null) {
        await ContactRepo.instance.createContact(contact);
      } else {
        await ContactRepo.instance.updateContact(contact);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    final title =
        isEditing ? context.getText('edit0001') : context.getText('creat001');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: firstNameCtrl,
              validator:
                  (value) =>
                      value!.isEmpty ? context.getText('required') : null,
              decoration: InputDecoration(
                labelText: context.getText('firstname'),
              ),
            ),
            TextFormField(
              controller: lastNameCtrl,
              validator:
                  (value) =>
                      value!.isEmpty ? context.getText('required') : null,
              decoration: InputDecoration(
                labelText: context.getText('lastname'),
              ),
            ),
            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              validator:
                  (value) =>
                      value!.isEmpty ? context.getText('required') : null,
              decoration: InputDecoration(labelText: context.getText('phone')),
            ),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator:
                  (value) =>
                      (!value!.contains('@') || value.isEmpty)
                          ? context.getText('invalidemail')
                          : null,
              decoration: InputDecoration(labelText: context.getText('email')),
            ),
            TextFormField(
              controller: addressCtrl,
              validator:
                  (value) =>
                      value!.isEmpty ? context.getText('required') : null,
              decoration: InputDecoration(
                labelText: context.getText('address'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveContact,
              child: Text(context.getText('save')),
            ),
          ],
        ),
      ),
    );
  }
}
