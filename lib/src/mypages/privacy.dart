import 'package:flutter/material.dart';
import '../utils/strings/lang.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const privacy());
}

class privacy extends StatefulWidget {
  static var body;

  const privacy({super.key});

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  @override
  Widget build(BuildContext context) {
    String icons = "";
    // accessible: 0xe03e
    icons += "\uE03e";
    // error:  0xe237
    icons += " \uE237";
    // fingerprint: 0xe287
    icons += " \uE287";
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("history"))),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(languageProvider.get("account")),
            subtitle: Text(languageProvider.get("sub_account")),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(languageProvider.get("requirement")),
            subtitle: Text(languageProvider.get("sub_requirement")),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(languageProvider.get("location")),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.person_2),
            title: Text(languageProvider.get("address_book")),
            subtitle: Text(languageProvider.get("sub_address_book")),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(languageProvider.get("search")),
            subtitle: Text(languageProvider.get("sub_search")),
            dense: true,
          ),
        ],
      ),
    );
  }
}
