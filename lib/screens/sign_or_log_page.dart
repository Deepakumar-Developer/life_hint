import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_hint/colors.dart';

import '../auth_services.dart';
import '../functions.dart';

class SignOrLogInPage extends StatefulWidget {
  const SignOrLogInPage({super.key});

  @override
  State<SignOrLogInPage> createState() => _SignOrLogInPageState();
}

class _SignOrLogInPageState extends State<SignOrLogInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: color_60,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: width * 0.3,
                    ),
                    SvgPicture.asset(
                      'assets/images/log_in_welcome.svg',
                      alignment: Alignment.bottomCenter,
                      semanticsLabel: 'Welcome You',
                      width: 200,
                      height: 150,
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: width * 0.05, right: width * 0.05),
                        width: width,
                        height: height * 0.55,
                        decoration: BoxDecoration(
                          color: color_30.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              SizedBox(
                                height: width * 0.05,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Life Hint',
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.w700,
                                    color: color_60,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20.0, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        optionSwitch = !optionSwitch;
                                      });
                                    },
                                    child: Text(
                                      optionSwitch ? 'Log In' : 'Sign Up',
                                      style: TextStyle(
                                        color: color_60,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.overline,
                                        decorationColor: color_60,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.only(
                                    bottom: 1.0, right: 10, left: 15),
                                decoration: BoxDecoration(
                                  color: color_60.withOpacity(0.2727),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  cursorColor: color_60,
                                  autocorrect: false,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: color_60),
                                  decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    labelStyle: TextStyle(color: color_60),
                                    hintText: '',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter E-mail';
                                    } else if (!(EmailValidator.validate(
                                        value))) {
                                      return 'Enter valid E-mail ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      padding: const EdgeInsets.only(
                                          bottom: 1.0, right: 10, left: 15),
                                      decoration: BoxDecoration(
                                        color: color_60.withOpacity(0.2727),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        cursorColor: color_60,
                                        autocorrect: false,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: color_60),
                                        obscureText: obscureText,
                                        obscuringCharacter: '*',
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle:
                                                TextStyle(color: color_60),
                                            hintText: '',
                                            border: InputBorder.none,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.remove_red_eye_rounded),
                                            ),
                                            suffixIconColor: obscureText
                                                ? color_30.withOpacity(0.5)
                                                : color_60),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Password';
                                          } else if (value.length < 8) {
                                            return 'Password must have 8 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  if (optionSwitch)
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 20, right: 20),
                                        padding: const EdgeInsets.only(
                                            bottom: 1.0, right: 10, left: 15),
                                        decoration: BoxDecoration(
                                          color: color_60.withOpacity(0.2727),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: TextFormField(
                                          controller: _ageController,
                                          cursorColor: color_60,
                                          autocorrect: false,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: color_60),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Age',
                                            labelStyle:
                                                TextStyle(color: color_60),
                                            hintText: ' 00',
                                            hintStyle:
                                                TextStyle(color: color_60),
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '*';
                                            } else if (value.length > 2) {
                                              return '**!';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (!optionSwitch)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Forget Password',
                                      style: TextStyle(
                                        fontSize: 12.50,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      showStack = !showStack;
                                      showTermsAndPolices = false;
                                    });

                                    if (okTermsAndPolices) {
                                      setState(() {
                                        showLoader = true;
                                      });
                                      optionSwitch
                                          ? signup(
                                              context,
                                              _emailController.text,
                                              _passwordController.text)
                                          : login(
                                              context,
                                              _emailController.text,
                                              _passwordController.text);
                                    }
                                    setState(() {
                                      okTermsAndPolices = false;
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.30, vertical: 20),
                                  width: width * 0.3,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: color_60,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      optionSwitch ? 'Create' : 'Log In',
                                      style: TextStyle(
                                        color: color_30,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: color_30,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showStack)
              Container(
                margin: const EdgeInsets.only(top: 18.0),
                padding: const EdgeInsets.all(10.0),
                width: width * 0.8,
                height: showTermsAndPolices ? width * 0.8 : width * 0.5,
                decoration: BoxDecoration(
                  color: color_30.withOpacity(0.85),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: width * 0.045,
                    ),
                    SvgPicture.asset(
                      'assets/images/agree.svg',
                      height: 100,
                      width: 100,
                      color: okTermsAndPolices ? null : color_60,
                    ),
                    SizedBox(
                      height: width * 0.045,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ListView(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showTermsAndPolices = !showTermsAndPolices;
                                });
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Terms and Policy',
                                  style: TextStyle(
                                      color: color_60,
                                      decorationColor: color_60,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: width * 0.04,
                            ),
                            if (showTermsAndPolices)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Teams:\nProduct Management: Defines the product vision, roadmap, and user stories. Conducts user research to understand user needs and habits, prioritizes features, and manages the product backlog.Development: Implements the app's functionality using Flutter or other suitable technologies. Integrates with Firebase for user authentication and data storage. Ensures code quality, performance, and maintainability.Security: Designs and implements security measures to protect user data. Conducts regular security audits and penetration testing. Stays informed about the latest security threats and best practices.Quality Assurance (QA): Creates and executes test cases to ensure app functionality and usability. Reports bugs and suggests improvements. Maintains high quality standards for the app.\nPolicies:\nUser Data Privacy: Clearly outlines what data is collected (notes, potentially user IDs), how it's used (stored in Firebase for retrieval), and with whom it's shared (not shared by default, consider anonymized analytics). Comply with relevant data privacy regulations (GDPR, CCPA). Provide users with control over their data (access, deletion, correction rights).Content Moderation: Establish clear guidelines on acceptable user content (no offensive or harmful material). Implement a content moderation system to review and potentially remove inappropriate content. Be transparent about what may be removed and how users can appeal decisions.Terms of Service: Define the legal agreement between users and the app. Cover topics like user eligibility, prohibited uses (sharing illegal content, violating user privacy), and limitations of liability. Make the terms easily accessible and understandable within the app.Backup and Recovery: Implement a robust backup strategy for user data stored in Firebase. Define procedures for recovering data in case of outage or disaster. Inform users about backup and recovery practices through the app or documentation.",
                                  style: TextStyle(
                                    color: color_60,
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: width * 0.04,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  okTermsAndPolices = !okTermsAndPolices;
                                });
                              },
                              child: Icon(
                                okTermsAndPolices
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank_rounded,
                                color: color_60,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Visibility(
              visible: showLoader,
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black45,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/loading_asset.svg',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: width * 0.3,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: LinearProgressIndicator(
                        color: color_30.withOpacity(0.9),
                        backgroundColor: color_30.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context, String email, password) async {
    final authServices = AuthServices();

    try {
      await authServices.signInWithEmailAndPassword(email, password);
      setState(() {
        showLoader = false;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: const Icon(
                  Icons.miscellaneous_services_rounded,
                  size: 30,
                ),
                iconColor: color_10,
                title: Text(
                  'Check Your Email name or Password',
                  style: TextStyle(
                      color: color_30,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ));
      setState(() {
        showLoader = false;
      });
    }
  }

  void logout() async {
    final authServices = AuthServices();
    authServices.signOut();
    setState(() {
      showLoader = false;
    });
  }

  void signup(BuildContext context, String email, password) async {
    final authServices = AuthServices();

    try {
      await authServices.signUpWithEmailAndPassword(email, password);
      await addAge(int.parse(_ageController.text));
      await addChildUser('null');
      setState(() {
        showLoader = false;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: const Icon(
                  Icons.network_check_rounded,
                  size: 30,
                ),
                iconColor: Colors.redAccent,
                title: Text(
                  'Check Your InterNet Speed',
                  style: TextStyle(
                      color: color_30,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ));
      setState(() {
        showLoader = false;
      });
    }
  }

  Future<void> addAge(age) async {
    CollectionReference notesCollection = fireStore.collection('LifeHint');
    if (FirebaseAuth.instance.currentUser != null) {
      notesCollection = notesCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');
    }

    await notesCollection.doc('age').set({'age': age});
  }

  Future<void> addChildUser(user) async {
    CollectionReference notesCollection = fireStore.collection('LifeHint');
    if (FirebaseAuth.instance.currentUser != null) {
      notesCollection = notesCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');
    }

    await notesCollection.doc('childUser').set({'child': user});
  }
}
