import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:provider/src/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTab extends StatefulWidget {

  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  var currentUser;

  @override
  void initState() {
    context.read<FirebaseService>().authStateChanges().listen((User? user) {
      if(user == null) {
        setState(() {
          currentUser = null;
        });
      } else {
        setState(() {
          currentUser = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: context.read<FirebaseService>().authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return currentUser == null? const Center(child: SignInWithGoogleButton()): UserProfile(user: currentUser,);
          }
        },
      ),
    );
  }
}


class UserProfile extends StatefulWidget {

  final user;
  const UserProfile({Key? key, this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: context.watch<MainModel>().appColor,
                      child: CachedNetworkImage(
                        imageUrl: widget.user.photoURL,
                        height: 100,
                        width: 100,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: Colors.white,
                              ),
                            ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Text(
                        widget.user.displayName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: context.watch<MainModel>().appColor,
                        )
                    ),
                    const SizedBox(height: 4,),
                    Text(
                        widget.user.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: context.watch<MainModel>().appColor,
                        )
                    ),
                    const SizedBox(height: 4),
                    const SignOutButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.black45,
                      onTap: () {
                        Navigator.of(context).pushNamed('/my-auctions');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.checklist_outlined, size: 30, color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(height: 6),
                            const Text(
                                'My Posted Items',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.black45,
                      onTap: () {
                        Navigator.of(context).pushNamed('/post-auction');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.file_upload_outlined, size: 30, color: Theme.of(context).colorScheme.secondary),
                            const SizedBox(height: 6),
                            const Text(
                                'Post Auction Item',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


