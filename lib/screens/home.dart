import 'package:appmid/screens/post_screen.dart';
import 'package:appmid/screens/profile.dart';
import 'package:appmid/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import 'login.dart';
import 'post_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Listening to the theme provider
    final themeListener = Provider.of<ThemeProvider>(context, listen: true);

    //  Theme provider functions variable
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          "assets/fz.png",
          fit: BoxFit.contain,
          width: 50,
          height: 50,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode,
                color: themeListener.isDark ? Colors.red : Colors.purple),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).switchMode();
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          color: const Color.fromARGB(182, 102, 21, 87),
          onPressed: () {
            logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false)
                });
          },
        ),
      ),
      body: currentIndex == 1 ? const PostScreen() : const Profile(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 102, 21, 87),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PostForm(
                    title: 'أضف منشور جديد',
                  )));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        surfaceTintColor: Colors.yellow,
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: currentIndex == 0
                      ? const Color.fromARGB(182, 102, 21, 87)
                      : const Color.fromARGB(255, 106, 106, 106),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: currentIndex == 1
                        ? const Color.fromARGB(182, 102, 21, 87)
                        : const Color.fromARGB(255, 106, 106, 106)),
                label: ''),
          ],
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
