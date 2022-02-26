import 'package:alpha/constants/constants.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alpha/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:provider/src/provider.dart';
import 'package:alpha/services/firebase_service.dart';

class AuctionPostPage extends StatefulWidget {
  const AuctionPostPage({Key? key}) : super(key: key);

  @override
  _AuctionPostPageState createState() => _AuctionPostPageState();
}

class _AuctionPostPageState extends State<AuctionPostPage> {

  late final _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 18, color: context.watch<MainModel>().appColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      contentPadding: const EdgeInsets.all(14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.pageAppBar(context, 'Post Auction Item'),
      body: const Center(
        child: Text('Post Auction'),
      )
    );
  }
}
