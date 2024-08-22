// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:moneyapp_speed_code/landingPage.dart';
import 'SignUp.dart'; // Import the SignUp page
import 'package:dio/dio.dart';

const Color backgroundColor2 = Color(0xFFEEEEEE);
const Color backgroundColor4 = Color(0xFFB2DFDB);
const Color textColor1 = Color(0xFF000000);
const Color textColor2 = Color(0xFF616161);
const Color buttonColor = Color(0xFF64DD17);
const Color formBackgroundColor =
    Color(0xFFF5F5F5); // Light gray for form background

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  var userData = {};

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      var response = await Dio().get('http://192.168.100.26:8000/user/get/?phone=${phone.text}');
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          userData = response.data;
        });
      }
    } catch(err) {
      print(err);
    }
  }

  void login() async {
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                backgroundColor2,
                backgroundColor2,
                backgroundColor4,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Image at the top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/logo.jpg', // Replace with your image asset
                      height: size.height *
                          0.35, // Set height to 35% of screen height
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Form positioned under the image
                Positioned(
                  top: size.height *
                      0.3, // Adjusted to position the form under the image
                  left: 0,
                  right: 0,
                  bottom: 0, // Extends the form to the bottom
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: const BoxDecoration(
                      color: formBackgroundColor, // Light gray for the form
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      height: 150,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.03),
                           Container(
                             child: TextFormField(
                               controller: phone,
                               keyboardType: TextInputType.number,
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               cursorColor: Colors.black45,
                               decoration: InputDecoration(
                                 contentPadding: const EdgeInsets.symmetric(
                                   horizontal: 20,
                                   vertical: 22,
                                 ),
                                 fillColor: Colors.white,
                                 filled: true,
                                 border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(30), // Increased border radius
                                   borderSide: BorderSide.none,
                                 ),
                                 hintText: 'Phone Number',
                                 hintStyle: const TextStyle(
                                   color: Colors.black45,
                                   fontSize: 19,
                                 ),
                                 prefixIcon: const Padding(
                                   padding: EdgeInsets.all(12.0),
                                   child: Icon(
                                     Icons.phone,
                                     color: Colors.black45,
                                   ),
                                 ),
                               ),
                               validator: (value) {
                                 if (value!.isEmpty) {
                                   return ('Cannot be empty');
                                 }
                                 if (!RegExp(
                                     r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]+$')
                                     .hasMatch(value)) {
                                   return ("Please enter a valid phone number");
                                 }
                                 return null;
                               },
                             )
                           ),
                            const SizedBox(
                              height: 20,
                            ),

                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: TextFormField(
                                controller: password,
                                keyboardType: TextInputType.text,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_isPasswordVisible, // Toggle visibility
                                cursorColor: Colors.black45,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 22,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 19,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible; // Toggle state
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ('Cannot be empty');
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Recovery Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor2,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            // Sign in button
                            ElevatedButton(
                              onPressed: () async {
                                final isValidForm = formKey.currentState!.validate();
                                if (isValidForm) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingPage()));
                                  getUser();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5, // Adds shadow to the button
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.login, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Sign In".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            // Register now text
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUp()),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: "Not a member? ",
                                  style: TextStyle(
                                    color: textColor2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Register now",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
