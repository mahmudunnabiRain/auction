import 'package:alpha/providers/main_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alpha/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/src/provider.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:truncate/truncate.dart';

class AuctionDetailsPage extends StatefulWidget {
  const AuctionDetailsPage({Key? key, required this.documentId}) : super(key: key);

  final documentId;

  @override
  _AuctionDetailsPageState createState() => _AuctionDetailsPageState();
}

class _AuctionDetailsPageState extends State<AuctionDetailsPage> {

  late final _formKey;
  bool bidFormVisibility = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    super.initState();
    checkEndDate();
  }

  Future<void> checkEndDate() async {
    DateTime endDate = await context.read<FirebaseService>().getEndDate(widget.documentId);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day-1);
    if(today.isBefore(endDate)) {
      setState(() {
        bidFormVisibility = true;
      });
    }
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
      appBar: CustomAppBar.pageAppBar(context, 'Auction Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: context.read<FirebaseService>().watchAuctionById(widget.documentId),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading"));
                }
                return Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data?['product_photo'],
                                fit: BoxFit.cover,
                                height: 200,
                                width: 200,
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
                            const SizedBox(height: 16,),
                            Center(child: Text(snapshot.data?['product_name'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)),
                            const SizedBox(height: 10,),
                            Text(
                              snapshot.data?['product_desc'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              'Minimum Bid Price: ${snapshot.data?['minimum_bid_price']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4,),
                            Text(
                              'Auction End Date: ${snapshot.data?['end_date'].toDate().month.toString()}-${snapshot.data?['end_date'].toDate().day.toString()}-${snapshot.data?['end_date'].toDate().year.toString()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8,),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Visibility(
              visible: bidFormVisibility,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Center(child: Text('Bid on this Auction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                      const SizedBox(height: 8,),
                      FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'bid_price',
                                decoration: customInputDecoration('Bid Price'),
                                onChanged: (text) {

                                },
                                validator: (value){
                                  if(value == null || value.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                },
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          )
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: const Text(
                          "Submit Bid",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            print("Form validated");
                            double bidPrice = double.parse(_formKey.currentState.value['bid_price']);
                            context.read<FirebaseService>().submitBid(context, widget.documentId, bidPrice);

                          } else {
                            print("validation failed");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Center(child: Text('Submitted Bids', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 8,),
                    StreamBuilder<QuerySnapshot>(
                      stream: context.read<FirebaseService>().watchSubmittedBids(widget.documentId),
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
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all()
                                  ),
                                  child: ListTile(
                                    onTap: () {

                                    },
                                    title: Text('\$ ${data['bid_price'].toString()} -- ${data['buyer_name']}'),
                                  ),
                                ),
                                const SizedBox(height: 4,),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
