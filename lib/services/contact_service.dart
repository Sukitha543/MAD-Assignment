import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static Future<Contact?> pickContact() async {
    // Request permission
    final status = await Permission.contacts.request();

    if (!status.isGranted) {
      throw Exception("Contacts permission denied");
    }

    // Open contacts
    final contact = await FlutterContacts.openExternalPick();

    return contact;
  }
}
