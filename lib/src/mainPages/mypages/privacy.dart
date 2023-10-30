import 'package:flutter/material.dart';
import 'package:pin_demo/main.dart';
import '../../strings/lang.dart';
import '../../components.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(privacy());
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
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.get("history"))),
      body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(languageProvider.get("account")),
              subtitle: Text(languageProvider.get("sub_account")),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(languageProvider.get("requirement")),
              subtitle: Text(languageProvider.get("sub_requirement")),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text(languageProvider.get("location")),
              
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.person_2),
              title: Text(languageProvider.get("address_book")),
              subtitle: Text(languageProvider.get("sub_address_book")),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text(languageProvider.get("search")),
              subtitle: Text(languageProvider.get("sub_search")),
              dense: true,
            ),
          ],
      ),
    
    );
  }
}
