import 'package:flutter/material.dart';
import 'package:my_app/provider/ConfigProvider.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigProvider()..loadConfig(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
