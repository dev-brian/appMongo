import 'package:flutter/material.dart';
import 'package:mongo/screens/groups_screens.dart';
import 'package:mongo/services/mongo_service.dart';
import 'package:mongo/widgets/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: tema1(),
        home: GroupsScreen());
  }
}
