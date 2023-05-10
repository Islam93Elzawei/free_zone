// ----- STRINGS ------

import 'package:appmid/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
const baseURL = 'http://192.168.1.123:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      floatingLabelAlignment: FloatingLabelAlignment.center,
      hintTextDirection: TextDirection.rtl,
      labelText: label,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// button

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor:
            // btncolor
            MaterialStateColor.resolveWith(
                (states) => const Color.fromARGB(182, 102, 21, 87)),
        padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(
    String text, String label, Function onTap, BuildContext context) {
  final themeListener = Provider.of<ThemeProvider>(context, listen: true);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
          onTap: () => onTap(),
          child: Text(text,
              style: const TextStyle(color: Color.fromARGB(182, 102, 21, 87)))),
      Text(label,
          style: TextStyle(
              color: themeListener.isDark ? Colors.white54 : Colors.black))
    ],
  );
}

// likes and comment btn

Expanded kLikeAndComment(
    int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text('$value')
            ],
          ),
        ),
      ),
    ),
  );
}
