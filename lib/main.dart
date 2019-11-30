import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/views/home_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        brightness: brightness, 
        primarySwatch: Colors.amber
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          theme: theme,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
        );
      }
    );
  }
}