

import 'dart:io';

import 'package:alpha/providers/main_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final FirebaseFirestore _fireStore;
  final FirebaseStorage _firebaseStorage;
  final FirebaseAuth _fireBaseAuth;
  final GoogleSignIn _googleSignIn;
  FirebaseService(this._fireStore, this._firebaseStorage, this._fireBaseAuth, this._googleSignIn);

  Stream<User?> authStateChanges() {
    return _fireBaseAuth.authStateChanges();
  }

  Future<User?> currentUser() async {
    return _fireBaseAuth.currentUser;
  }

  String currentUserName() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return currentUser.displayName!;
    }
    return "No User";
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _fireBaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      GlobalSnackBarBloc.showMessage(
          GlobalMsg(e.message.toString(), bgColor: Colors.red)
      );
    }
  }


  Future<void> signOut() async {
    await _fireBaseAuth.signOut().then( (_) {
      _googleSignIn.signOut();
    });
  }

  Future<void> postAuctionItem(BuildContext context, String productName, String productDesc, List productPhoto, double minimumBidPrice, DateTime endDate) async {
    context.loaderOverlay.show();
    var uid = _fireBaseAuth.currentUser?.uid;
    var sellerName = _fireBaseAuth.currentUser?.displayName;
    File file = File(productPhoto.first.path);
    var imageRef = _firebaseStorage.ref(const Uuid().v4());
    try {
      await imageRef.putFile(file);
      var imageUrl = await imageRef.getDownloadURL();
      // Call the auction's CollectionReference to add a new auction
      CollectionReference auctions = _fireStore.collection('auction');
      return await auctions
          .add({
        'uid': uid,
        'seller_name': sellerName,
        'product_name': productName,
        'product_desc': productDesc,
        'product_photo': imageUrl,
        'minimum_bid_price': minimumBidPrice,
        'end_date': endDate,
      }).then((value) {
        context.loaderOverlay.hide();
        GlobalSnackBarBloc.showMessage(
          GlobalMsg("Your auction item has been published.", bgColor: Colors.green),
        );
      });
    }
    on FirebaseException catch (e) {
      context.loaderOverlay.hide();
      GlobalSnackBarBloc.showMessage(GlobalMsg("Failed to post auction-item.", bgColor: Colors.red),);
    }
  }

  Future<void> submitBid(BuildContext context, String documentId, double bidPrice) async {
    context.loaderOverlay.show();
    var uid = _fireBaseAuth.currentUser?.uid;
    var buyerName = _fireBaseAuth.currentUser?.displayName;
    try {
      // Call the auction's CollectionReference to add a new auction
      CollectionReference auctions = _fireStore.collection('auction').doc(documentId).collection('bids');
      return await auctions
          .add({
        'uid': uid,
        'buyer_name': buyerName,
        'bid_price': bidPrice
      }).then((value) {
        context.loaderOverlay.hide();
        GlobalSnackBarBloc.showMessage(
          GlobalMsg("Your bid has been submitted.", bgColor: Colors.green),
        );
      });
    }
    on FirebaseException catch (e) {
      context.loaderOverlay.hide();
      GlobalSnackBarBloc.showMessage(GlobalMsg("Failed to submit bid.", bgColor: Colors.red),);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAuctions(){
    return _fireStore.collection('auction').snapshots();
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchAuctionById(String documentId){
    return _fireStore.collection('auction').doc(documentId).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> watchSubmittedBids(String documentId){
    return _fireStore.collection('auction').doc(documentId).collection('bids').orderBy('bid_price', descending: true).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> watchMyAuctions(){
    var uid = _fireBaseAuth.currentUser?.uid;
    return _fireStore.collection('auction')
      .where('uid', isEqualTo: uid)
      .snapshots();
  }

  Future<DateTime> getEndDate(String documentId) async {
    var doc = await _fireStore.collection('auction').doc(documentId).get();
    DateTime endDate = doc['end_date'].toDate();
    return endDate;
  }

}

class SignInWithGoogleButton extends StatefulWidget {
  const SignInWithGoogleButton({Key? key}) : super(key: key);

  @override
  _SignInWithGoogleButtonState createState() => _SignInWithGoogleButtonState();
}

class _SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          //minimumSize: const Size(double.infinity, 50)
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: context.read<MainModel>().appColor)
          )
      ),
      icon: Image.asset("assets/images/google_logo.png", width: 26, height: 26,),
      label: const Text('Sign in with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onPressed: () {
        context.read<FirebaseService>().signInWithGoogle();
      },
    );
  }
}

class SignOutButton extends StatefulWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  _SignOutButtonState createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            )
        ),
      ),
      child: const Text(
          'Sign Out',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)
      ),
      onPressed: () {
        context.read<FirebaseService>().signOut();
      },
    );
  }
}