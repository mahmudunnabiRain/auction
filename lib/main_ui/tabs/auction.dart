import 'package:alpha/providers/main_provider.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/src/provider.dart';
import 'package:truncate/truncate.dart';

class AuctionTab extends StatefulWidget {
  const AuctionTab({Key? key}) : super(key: key);

  @override
  _AuctionTabState createState() => _AuctionTabState();
}

class _AuctionTabState extends State<AuctionTab> {

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var currentUser = await context.read<FirebaseService>().currentUser();
            if(currentUser != null) {
              Navigator.of(context).pushNamed('/post-auction');
            } else {
              GlobalSnackBarBloc.showMessage(GlobalMsg("Sign in to post auction item.", bgColor: Colors.red),);
              context.read<MainModel>().changeTabIndex(2);
            }

          },
          mini: true,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<FirebaseService>().watchAuctions(),
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


