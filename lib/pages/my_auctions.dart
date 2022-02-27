import 'package:alpha/components/app_bar.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';
import 'package:truncate/truncate.dart';

class MyAuctionsPage extends StatefulWidget {
  const MyAuctionsPage({Key? key}) : super(key: key);

  @override
  _MyAuctionsPageState createState() => _MyAuctionsPageState();
}

class _MyAuctionsPageState extends State<MyAuctionsPage> {

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
    return LoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar.pageAppBar(context, 'My Posted Items'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<FirebaseService>().watchMyAuctions(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  context.loaderOverlay.show();
                  return const Center(child: Text("Loading"));
                }
                context.loaderOverlay.hide();
                return Column(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        isThreeLine: true,
                        onTap: () {
                          Navigator.of(context).pushNamed('/auction-details', arguments: document.id);
                        },
                        leading: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                  style: BorderStyle.solid
                              )
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data['product_photo'],
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
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
                        title: Text(truncate(data['product_name'], 36, omission: "...", position: TruncatePosition.end)),
                        subtitle: Text(truncate(data['product_desc'], 80, omission: "...", position: TruncatePosition.end)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}