import 'package:appmid/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: Consumer<ThemeProvider>(builder: (context, themeConsumer, child) {
        return MaterialApp(
          theme: ThemeData(
              // FROM HERE
              textTheme: Theme.of(context).textTheme.copyWith(
                    // ignore: deprecated_member_use
                    subtitle1: TextStyle(
                        color:
                            themeConsumer.isDark ? Colors.white : Colors.black),
                  ),
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: themeConsumer.isDark
                              ? Colors.white
                              : Colors.black38)),
                  //      focusColor:  OutlineInputBorder(
                  // borderSide: BorderSide(
                  //     width: 1,
                  //     color: themeConsumer.isDark
                  //         ? Colors.white
                  //         : Colors.black38)),

                  hintStyle: TextStyle(
                      color:
                          themeConsumer.isDark ? Colors.white : Colors.black),
                  labelStyle: TextStyle(
                      color:
                          themeConsumer.isDark ? Colors.white : Colors.black)),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor:
                      themeConsumer.isDark ? Colors.black87 : Colors.white),
              bottomAppBarTheme: BottomAppBarTheme(
                  color: themeConsumer.isDark ? Colors.black87 : Colors.white),
              appBarTheme: AppBarTheme(
                  backgroundColor:
                      themeConsumer.isDark ? Colors.black87 : Colors.white),
              scaffoldBackgroundColor:
                  themeConsumer.isDark ? Colors.black87 : Colors.white),
          debugShowCheckedModeBanner: false,
          home: const Loading(),
        );
      }),
    );
  }
}
