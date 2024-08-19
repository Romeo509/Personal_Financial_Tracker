import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:moneyapp_speed_code/authPages/SignIn.dart'; // Import your SignIn page

const Color backgroundColor2 = Color(0xFFEEEEEE);
const Color backgroundColor4 = Color(0xFFB2DFDB);
const Color textColor1 = Color(0xFF000000);
const Color textColor2 = Color(0xFF616161);
const Color buttonColor = Color(0xFF64DD17);
const Color formBackgroundColor =
    Color(0xFFF5F5F5); // Light gray for form background

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.03),
                          // Text fields
                          myTextField(
                              "Enter first name", Icons.person, Colors.black45,
                              controller: firstNameController),
                          myTextField(
                              'Enter last name', Icons.person, Colors.black45,
                              controller: lastNameController),
                          myTextField(
                              'Choose username', Icons.person, Colors.black45,
                              controller: usernameController),
                          myTextField(
                              'Enter phone number', Icons.phone, Colors.black45,
                              controller: phoneController),
                          myTextField(
                              "Enter email", Icons.email, Colors.black45,
                              controller: emailController),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText:
                                  !_isPasswordVisible, // Toggle visibility
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
                            ),
                          ),
                          SizedBox(height: size.height * 0.013),
                          // Register button
                          ElevatedButton(
                            onPressed: () async {
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                try {
                                  await Dio().post(
                                      'http://192.168.100.26:8000/signup/user/',
                                      data: {
                                        'first_name': firstNameController.text,
                                        'last_name': lastNameController.text,
                                        'username': usernameController.text,
                                        'phone': phoneController.text,
                                        'email': emailController.text,
                                        'password': passwordController.text,
                                      });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignIn(), // Navigate to SignIn page
                                    ),
                                  );
                                } catch (err) {
                                  print(err);
                                }
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
                                const Icon(Icons.app_registration,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  "Register".toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          // Sign in text
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SignIn(), // Navigate to SignIn page
                                ),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: textColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container myTextField(String hint, IconData icon, Color color,
      {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        cursorColor: color,
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
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 19,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
