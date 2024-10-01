import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_hint/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth_services.dart';
import '../functions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _childKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesTitle = TextEditingController();
  late final TextEditingController _notesContent = TextEditingController();
  final _childUser = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_30.withOpacity(0.5),
        foregroundColor: Colors.white,
        leading: (age > 20)
            ? null
            : GestureDetector(
                onTap: logout,
                child: Icon(
                  Icons.logout_rounded,
                  color: color_60,
                ),
              ),
        title: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onDoubleTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'copy This',
                    style: TextStyle(
                        color: color_30,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    TextField(
                      controller: TextEditingController(
                          text: FirebaseAuth.instance.currentUser!.uid),
                      readOnly: true,
                    )
                  ],
                ),
              );
            },
            onTap: getData,
            child: const Text(
              'Life Hint',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 22.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      drawer: age > 20
          ? Drawer(
              backgroundColor: color_30.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: width * 0.15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: color_30,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0), color: Colors.black12)
                          ]),
                      child: SvgPicture.asset(
                        'assets/images/mail_send.svg',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      height: width * 0.055,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        icon: SvgPicture.asset(
                                          'assets/images/construction.svg',
                                          width: 100,
                                          height: 100,
                                        ),
                                        actions: [
                                          Form(
                                            key: _childKey,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: _childUser,
                                                    obscureText: true,
                                                    keyboardType:
                                                        TextInputType.none,
                                                    decoration: InputDecoration(
                                                      label: Text(
                                                        'Enter copied string in child account',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: color_30),
                                                      ),
                                                      hintText:
                                                          ' double tap the Life Hint in this page',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .black26),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter uid';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (_childKey.currentState!
                                                        .validate()) {
                                                      showToast(
                                                          'Are you sure want to connect this Account');
                                                      showToast(
                                                          'Double tap to connect');
                                                    }
                                                  },
                                                  onDoubleTap: () {
                                                    if (_childKey.currentState!
                                                        .validate()) {
                                                      addChildUser(
                                                          _childUser.text);
                                                      _childUser.clear();
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.link_rounded,
                                                    color: color_30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              height: 75,
                              decoration: BoxDecoration(
                                color: color_60,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.link_rounded,
                                    color: color_30,
                                  ),
                                  Text(
                                    'Add children Account',
                                    style: TextStyle(
                                      color: color_30,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationColor: color_30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (childUid !=
                              FirebaseAuth.instance.currentUser!.uid)
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: fireStore
                                    .collection('LifeHint')
                                    .doc(childUid)
                                    .collection('hint')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        child: LinearProgressIndicator(
                                          color: color_30.withOpacity(0.5),
                                          backgroundColor:
                                              color_30.withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return ListView(
                                      children: snapshot.data!.docs
                                          .map((hint) => childTail(hint))
                                          .toList(),
                                    );
                                  }
                                  return Center(
                                    child: SvgPicture.asset(
                                      'assets/images/null.svg',
                                      width: 250,
                                      height: 250,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Powered by : ',
                          style: TextStyle(
                            color: color_60,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 20),
                      child: TextButton(
                        child: Text(
                          'ByteWise Creator',
                          style: TextStyle(
                            color: color_60,
                          ),
                        ),
                        onPressed: () {
                          launch('https://bitwisesample.netlify.app/');
                        },
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          logout();
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            color: color_60,
                          ),
                          title: Text(
                            'Log Out',
                            style: TextStyle(color: color_60),
                          ),
                        ))
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: color_30.withOpacity(0.5),
        foregroundColor: color_60,
        splashColor: color_60.withOpacity(0.7),
        onPressed: () {
          setState(() {
            showTextField = true;
          });
        },
        child: const Icon(
          Icons.add_task_rounded,
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection('LifeHint')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('hint')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: LinearProgressIndicator(
                        color: color_30.withOpacity(0.5),
                        backgroundColor: color_30.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    children: snapshot.data!.docs
                        .map((hint) => gridCard(hint))
                        .toList(),
                  );
                }
                return Center(
                  child: SvgPicture.asset(
                    'assets/images/null.svg',
                    width: 250,
                    height: 250,
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: showTextField,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: color_30.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              width: width * 0.8,
              height: height * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    height: width * 0.05,
                    child: GestureDetector(
                      onTap: () {
                        _notesContent.clear();
                        _notesTitle.clear();
                        setState(() {
                          showTextField = false;
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.clear,
                          color: color_60,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38.0, right: 10),
                          child: SvgPicture.asset(
                            'assets/images/add_notes.svg',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'New Hint',
                          style: TextStyle(
                              color: color_60,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.overline,
                              decorationColor: color_60),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.only(
                                bottom: 1.0, right: 10, left: 15),
                            decoration: BoxDecoration(
                              color: color_60.withOpacity(0.2727),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextFormField(
                              controller: _notesTitle,
                              cursorColor: color_60,
                              autocorrect: false,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: color_60),
                              decoration: InputDecoration(
                                labelText: 'Notes Title',
                                labelStyle: TextStyle(color: color_60),
                                hintText: '',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title Mandatory';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20.0),
                            padding: const EdgeInsets.only(
                                bottom: 1.0, right: 10, left: 15),
                            decoration: BoxDecoration(
                              color: color_60.withOpacity(0.2727),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextFormField(
                              controller: _notesContent,
                              cursorColor: color_60,
                              autocorrect: false,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: color_60),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Content',
                                labelStyle: TextStyle(color: color_60),
                                hintText: '',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value!.length < 10) {
                                  return 'Add more content';
                                }
                                return null;
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                addNote(Note(
                                  id: 'id',
                                  title: _notesTitle.text,
                                  content: _notesContent.text,
                                  createdAt: DateTime.now(),
                                ));
                                _notesContent.clear();
                                _notesTitle.clear();
                                setState(() {
                                  showTextField = false;
                                  id += 1;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.28, vertical: 20),
                              width: width * 0.3,
                              height: height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: color_60,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: color_30,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: showDelete,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: height * 0.4,
                width: width * 0.65,
                decoration: BoxDecoration(
                  color: color_30.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      'assets/images/delete_notes.svg',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      deleteTitle,
                      style: TextStyle(
                        color: color_60,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showDelete = false;
                            });
                          },
                          child: Container(
                            width: width * 0.25,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: color_60,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Not Now',
                                style: TextStyle(
                                  color: color_30,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: color_30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await fireStore
                                .collection('LifeHint')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('hint')
                                .doc(deleteId)
                                .delete();
                            setState(() {
                              showDelete = false;
                            });
                          },
                          child: Container(
                            width: width * 0.25,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: color_60,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: color_30,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: color_30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void logout() async {
    final authServices = AuthServices();
    authServices.signOut();
    setState(() {
      showLoader = false;
    });
  }

  Widget gridCard(QueryDocumentSnapshot doc) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showDelete = true;
          deleteTitle = doc['title'];
          deleteId = doc['id'];
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color_30.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    doc['title'],
                    style: TextStyle(
                      color: color_60,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDelete = true;
                      deleteTitle = doc['title'];
                      deleteId = doc['id'];
                    });
                  },
                  child: Icon(
                    Icons.delete_rounded,
                    color: color_60.withOpacity(0.9),
                  ),
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(children: [
                Text(
                  doc['content'],
                  style: TextStyle(
                    color: color_60,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget childTail(QueryDocumentSnapshot doc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: color_60,
      ),
      child: Text(doc['title']),
    );
  }

  Future<void> addNote(Note note) async {
    CollectionReference notesCollection = fireStore.collection('LifeHint');
    if (FirebaseAuth.instance.currentUser != null) {
      notesCollection = notesCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('hint');
    }

    String noteId = DateTime.now().millisecondsSinceEpoch.toString();

    await notesCollection.doc(noteId).set({
      'id': noteId,
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
    });
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

  Future<void> getData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('LifeHint');
    if (FirebaseAuth.instance.currentUser != null) {
      collectionRef = collectionRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');
    }

    final docSnapshotAge = await collectionRef.doc('age').get()
        as DocumentSnapshot<Map<String, dynamic>>;

    if (!docSnapshotAge.exists) {
      print('Document does not exist!');
      return;
    }

    // Extract the data
    final data = docSnapshotAge.data();
    if (data != null) {
      setState(() {
        age = data['age'];
      });
    }

    final docSnapshotUserId = await collectionRef.doc('childUser').get()
        as DocumentSnapshot<Map<String, dynamic>>;

    if (!docSnapshotUserId.exists) {
      print('Document does not exist!');
      return;
    }

    // Extract the data
    final dataUid = docSnapshotUserId.data();
    if (dataUid != null) {
      setState(() {
        childUid = dataUid['child'];
      });
    }
    print('age $age uid $childUid');
  }
}
