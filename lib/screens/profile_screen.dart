import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_chat/api/apis.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Section'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .04,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .2),
                    child: CachedNetworkImage(
                      height: mq.height * .22,
                      width: mq.height * .22,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  // to edit user image
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {},
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
              ),
              SizedBox(
                height: mq.height * .05,
              ),
              ElevatedButton.icon(
                onPressed: () {},
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
                                  builder: (context) => const LoginScreen()));
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
    );
  }
}
