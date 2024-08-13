import 'package:flutter/material.dart';
import 'SignUp.dart'; // Import the SignUp page
import '../Utils/colors.dart';

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
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: Container(
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
                  decoration: BoxDecoration(
                    color: formBackgroundColor, // Light gray for the form
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.03),
                      // Username field
                      myTextField(
                          "Enter username", Icons.person, Colors.black45),
                      // Password field with eye icon
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
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
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
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
                      const SizedBox(height: 10),
                      Align(
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5, // Adds shadow to the button
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Sign In".toUpperCase(),
                              style: TextStyle(
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
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: Text.rich(
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
            ],
          ),
        ),
      ),
    );
  }

  Container myTextField(String hint, IconData icon, Color color,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
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
