import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/name_page.dart';
import 'session.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final savedName = await Session.loadSavedName();
  runApp(App(initialName: savedName));
}

class App extends StatelessWidget {
  final String? initialName;

  const App({super.key, this.initialName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yappin',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: NamePage(initialName: initialName),
    );
  }
}
