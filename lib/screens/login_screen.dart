// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn/helpers/loading.dart';
import 'package:learn/model/account.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passwordFieldKey = GlobalKey<FormBuilderFieldState>();
  bool _isLoading = false;
  bool remember = true;
  String errorMessage = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AutovalidateMode autoValidate = AutovalidateMode.onUserInteraction;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Account myAccount =
      Account(id: 1, email: 'trongnham2003@gmail.com', password: '123123');

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogin() async {
      try {
        final form = _formKey.currentState;
        if (form!.validate() != true) {
          setState(() {
            autoValidate = AutovalidateMode.always;
          });
          return;
        }
        // setState(() {
        //   _isLoading = true;
        // });
        await Future.delayed(const Duration(seconds: 3));
        if (emailController.text == myAccount.email &&
            passwordController.text == myAccount.password) {
          Fluttertoast.showToast(
            msg: 'Login Success',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: const Color.fromARGB(255, 237, 94, 84),
            textColor: Colors.white,
            webPosition: 'top',
          );
          if (!mounted) return;
          // await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const HomeScreen(name: 'Nham 215')));
        } else {
          Fluttertoast.showToast(
            msg: 'Email has not been register!!',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.amber,
            textColor: Colors.white,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    signInWithGoogle() async {
      try {
        setState(() {
          _isLoading = true;
        });
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FormBuilder(
                enabled: !_isLoading,
                onChanged: () {
                  if (errorMessage.isNotEmpty) {
                    setState(() {
                      errorMessage = '';
                    });
                  }
                },
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 45, horizontal: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Image.asset('assets/images/logo_ale.png'),
                            ),
                            const Text(
                              'Welcome to Mina!',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const Text(
                              'Log in to Mina discover interesting things.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50),
                                child: Column(
                                  children: [
                                    TextFieldTapRegion(
                                        child: FormBuilderTextField(
                                      controller: emailController,
                                      name: 'email',
                                      autovalidateMode: autoValidate,
                                      key: _emailFieldKey,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: Color(0xFFFAFAFA),
                                      ),
                                      onSubmitted: (_) => handleLogin(),
                                      validator: FormBuilderValidators.compose(
                                        [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Please enter your email address."),
                                          FormBuilderValidators.email(
                                              errorText:
                                                  "Email is invalid. Please try again!"),
                                        ],
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                        prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF3D3737)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF1E8F8E),
                                            width: 2.0,
                                          ),
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        hintText: 'Email',
                                      ),
                                    )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFieldTapRegion(
                                        child: FormBuilderTextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      name: 'password',
                                      autovalidateMode: autoValidate,
                                      key: _passwordFieldKey,
                                      style: const TextStyle(
                                        color: Color(0xFFFAFAFA),
                                      ),
                                      onSubmitted: (_) => handleLogin(),
                                      validator: FormBuilderValidators.compose(
                                        [
                                          FormBuilderValidators.required(
                                              errorText:
                                                  "Please enter your password."),
                                          FormBuilderValidators.minLength(4,
                                              errorText:
                                                  "Password least 4 characters"),
                                        ],
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                        prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                              color: Color(
                                                  0xFF3D3737)), // Màu border #3D3737
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF1E8F8E),
                                            width: 2.0,
                                          ),
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        hintText: 'Password',
                                      ),
                                    )),
                                  ],
                                )),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: Container(
                                        height: 1,
                                        color: const Color(0xFF85858A),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'or continue with e-mail',
                                      style: TextStyle(
                                        color: Color(0xFF85858A),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.9,
                                      child: Container(
                                        height: 1,
                                        color: const Color(0xFF85858A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 48,
                              margin: const EdgeInsets.symmetric(vertical: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  signInWithGoogle();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: const Color(0xFF1A1D21),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isLoading
                                        ? const LoadingUI()
                                        : Image.asset(
                                            'assets/images/google.png',
                                            height: 24,
                                            width: 24,
                                          ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Sign In with Google',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(children: [
                                        Checkbox(
                                          value: remember,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              remember = value!;
                                            });
                                          },
                                          activeColor: const Color(0xFF1E8F8E),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              remember = !remember;
                                            });
                                          },
                                          child: Text(
                                            'Remember me',
                                            style: TextStyle(
                                              color: remember
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                    const Text(
                                      'Forgot password',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              width: double.infinity,
                              height: 45,
                              margin: const EdgeInsets.symmetric(vertical: 35),
                              child: OutlinedButton(
                                onPressed: _isLoading ? null : handleLogin,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: const Color(0xFF1E8F8E),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don’t have an account? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ],
                )),
          ),
        ));
  }
}
