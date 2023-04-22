// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_chat/api/apis.dart';
import 'package:in_chat/helper/dialogs.dart';
import 'package:in_chat/main.dart';
import 'package:in_chat/models/chat_user.dart';
import 'package:in_chat/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Section'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .04,
                  ),
                  Stack(
                    children: [
                      _image != null
                          // show local image
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .2),
                              child: Image.file(
                                File(_image!),
                                height: mq.height * .22,
                                width: mq.height * .22,
                                fit: BoxFit.cover,
                              ),
                            )

                          // show image from server
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .2),
                              child: CachedNetworkImage(
                                height: mq.height * .22,
                                width: mq.height * .22,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      // to edit user image
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          elevation: 1.5,
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(
                    height: mq.height * .04,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.indigo,
                      ),
                      hintText: 'E.g., John Doe',
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onSaved: (value) => APIs.self.name = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : '* Required Field',
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  TextFormField(
                      initialValue: widget.user.about,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.indigo,
                        ),
                        hintText: 'E.g., Feeling Excited',
                        labelText: 'About',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onSaved: (value) => APIs.self.about = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : '* Required Field'),
                  SizedBox(
                    height: mq.height * .05,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        log('Form Validated');
                        _formKey.currentState!.save();
                        APIs.updateUserDetl().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Updated Successfully');
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      'Update',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(mq.width * .45, mq.height * .055),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .13,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 10),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await APIs.fireauth.signOut().then((value) async {
                            await GoogleSignIn().signOut().then((value) {
                              // Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                              // await Future.delayed(const Duration(seconds: 3))
                              //     .then((value) {
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => const LoginScreen()));
                              // });
                            });
                          });
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'LOGOUT',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const StadiumBorder(),
                          fixedSize: Size(mq.width * .35, mq.height * .065),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // bottom sheet when clicked on profile pic edit button
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
              padding: EdgeInsets.only(
                  top: mq.height * 0.03, bottom: mq.height * 0.05),
              shrinkWrap: true,
              children: [
                const Text(
                  'Select Profile Pic from',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: mq.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (photo != null) {
                          log('Image path: ${photo.path} --mimeType: ${photo.mimeType}');
                          setState(() {
                            _image = photo.path;
                          });

                          APIs.updateProfilePic(File(_image!));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade100,
                        shape: const CircleBorder(),
                        fixedSize: Size(
                          mq.width * .25,
                          mq.height * .15,
                        ),
                      ),
                      child: Image.asset('assets/images/camera.png'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image path: ${image.path} --mimeType: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePic(_image as File);

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade100,
                        shape: const CircleBorder(),
                        fixedSize: Size(
                          mq.width * .25,
                          mq.height * .15,
                        ),
                      ),
                      child: Image.asset('assets/images/gallery.png'),
                    ),
                  ],
                ),
              ]);
        });
  }
}
