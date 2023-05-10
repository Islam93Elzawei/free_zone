import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:appmid/models/api_response.dart';
import 'package:appmid/models/user.dart';
import 'package:appmid/services/user_service.dart';
import '../constant.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //update profile
  void updateProfile() async {
    String? imageString =
        _imageFile != null ? getStringImage(_imageFile!) : null;
    ApiResponse response =
        await updateUser(txtNameController.text, imageString);
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: ListView(
                children: [
                  const Text(
                    "بيانات المستخدم",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 207, 206, 206)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: const DecorationImage(
                              image: AssetImage('assets/mm.jpg'),
                              fit: BoxFit.cover),
                          color: Colors.amber),
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: txtNameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        fillColor: Color.fromARGB(255, 217, 217, 217),
                        filled: true,
                        hintText: 'الاسم',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 217, 217, 217),
                          fontFamily:
                              'Arabic', // Add this line to set the font family for the hint text
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  kTextButton('تحديث', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      updateProfile();
                    }
                  })
                ],
              ),
            ),
          );
  }
}
