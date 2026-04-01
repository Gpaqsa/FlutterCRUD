import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/objects_viewmodel.dart';
import 'views/list_screen.dart';
import 'core/theme.dart';

void main() {
  runApp(
    // Provide the ObjectsViewModel to the widget tree
    ChangeNotifierProvider(
      create: (_) => ObjectsViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restful API Demo APP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      home: const ListScreen(),
    );
  }
}
