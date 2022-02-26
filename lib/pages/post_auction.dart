import 'package:alpha/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:alpha/components/app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    return LoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar.pageAppBar(context, 'Post Auction Item'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text('Insert Auction Item Information', style: TextStyle(fontSize: 18),),
              const SizedBox(height: 14,),
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                        child: FormBuilderTextField(
                          name: 'product_name',
                          decoration: customInputDecoration('Product Name'),
                          onChanged: (text) {

                          },
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: FormBuilderTextField(
                          name: 'product_desc',
                          decoration: customInputDecoration('Description'),
                          maxLines: 4,
                          onChanged: (text) {

                          },
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: FormBuilderImagePicker(
                          name: 'product_photo',
                          decoration: customInputDecoration('Product Photo'),
                          maxImages: 1,
                          validator: (value){
                            if(value == null) {
                              return "You must provide an image";
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: FormBuilderTextField(
                          name: 'minimum_bid_price',
                          decoration: customInputDecoration('Minimum Bid Price'),
                          onChanged: (text) {

                          },
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'This field cannot be empty';
                            }
                          },
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: FormBuilderDateTimePicker(
                          name: 'end_date',
                          // onChanged: _onChanged,
                          inputType: InputType.date,
                          decoration: customInputDecoration('End Date'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          // initialValue: DateTime.now(),
                          // enabled: true,
                        ),
                      ),
                      const SizedBox(height: 20,),

                    ],
                  )
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Text(
                        "Post",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        _formKey.currentState.save();
                        if (_formKey.currentState.validate()) {
                          print(_formKey.currentState.value);
                          var productName = _formKey.currentState.value['product_name'];
                          var productDesc = _formKey.currentState.value['product_desc'];
                          var productPhoto = _formKey.currentState.value['product_photo'];
                          var minimumBidPrice = _formKey.currentState.value['minimum_bid_price'];
                          var endDate = _formKey.currentState.value['end_date'];
                          // upload auction-item information
                          await context.read<FirebaseService>().postAuctionItem(
                              context,
                              productName,
                              productDesc,
                              productPhoto,
                              minimumBidPrice,
                              endDate);
                          Navigator.pop(context);

                        } else {
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState.reset();
                      },
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
