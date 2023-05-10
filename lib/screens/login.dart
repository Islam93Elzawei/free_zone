import 'package:appmid/models/api_response.dart';
import 'package:appmid/models/user.dart';
import 'package:appmid/services/user_service.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/userlg.png",
              height: 200,
              width: 0,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "تسجيل الدخول",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 164, 163, 163)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              textDirection: TextDirection.rtl,
              validator: (val) =>
                  val!.isEmpty ? 'عنوان البريد الإلكتروني غير صالح' : null,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(182, 102, 21, 87)),
                  ),
                  // fillColor: Color.fromARGB(255, 243, 243, 243),
                  filled: true,
                  hintText: 'البريد الالكتروني',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: txtPassword,
              textDirection: TextDirection.rtl,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'مطلوب 6 أحرف على الأقل' : null,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(182, 102, 21, 87)),
                  ),
                  // fillColor: Color.fromARGB(255, 243, 243, 243),
                  filled: true,
                  hintText: 'كلمة المرور',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 10,
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(182, 102, 21, 87)),
                  )
                : kTextButton('تسجيل الدخول', () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
            const SizedBox(
              height: 10,
            ),
            kLoginRegisterHint('تسجيل؟', '  ليس لديك حساب؟ ', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Register()),
                  (route) => false);
            }, context)
          ],
        ),
      ),
    );
  }
}
