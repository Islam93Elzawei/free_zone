import 'package:appmid/models/api_response.dart';
import 'package:appmid/models/user.dart';
import 'package:appmid/screens/home.dart';
import 'package:appmid/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../provider/theme_provider.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  get width => null;

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
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
    // ignore: unused_local_variable
    final themeListener = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/useregs.png',
              height: 200,
              width: 0,
            ),
            const Text(
              "انشاء حساب",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 207, 206, 206)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              textDirection: TextDirection.rtl,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(182, 102, 21, 87)),
                  ),
                  filled: true,
                  hintText: 'اسم مستخدم ',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(182, 102, 21, 87))),
                  filled: true,
                  hintText: 'البريد الالكتروني',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
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
                  filled: true,
                  hintText: 'كلمة المرور ',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordConfirmController,
              textDirection: TextDirection.rtl,
              obscureText: true,
              validator: (val) => val != passwordController.text
                  ? 'كلمة المرور غير مطابقة'
                  : null,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(182, 102, 21, 87)),
                  ),
                  filled: true,
                  hintText: ' تاكيد كلمة المرور',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 130, 130, 130))),
            ),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const Center(child: CircularProgressIndicator())
                : kTextButton(
                    'تسجيل ',
                    () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    },
                  ),
            const SizedBox(
              height: 20,
            ),
            kLoginRegisterHint('تسجيل الدخول ', 'هل لديك حساب ؟  ', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            }, context)
          ],
        ),
      ),
    );
  }
}
