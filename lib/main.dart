import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_snack_bar/global_snack_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:alpha/routes/route_generator.dart';
import 'package:alpha/services/firebase_service.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:alpha/providers/counter_provider.dart';
import 'package:alpha/providers/main_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CounterModel()),
          ChangeNotifierProvider(create: (context) => MainModel()),
          Provider(create: (_) => FirebaseService(FirebaseFirestore.instance, FirebaseStorage.instance, FirebaseAuth.instance, GoogleSignIn())),
          StreamProvider(create: (context) => context.read<FirebaseService>().authStateChanges(), initialData: null)
        ],
        child: EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('bn')],
          path: 'assets/translations', // <-- change the path of the translation files
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp(),
        ),
      ),

  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void initState() {
    checkConnectivity();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _appLifeCycleState = AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _appLifeCycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _appLifeCycleState = state; });
  }

  void checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if(_appLifeCycleState == AppLifecycleState.resumed) {
        switch (result) {
          case ConnectivityResult.none: {
            GlobalSnackBarBloc.showMessage(
              GlobalMsg("Internet connection lost", bgColor: Colors.red),
            );
          }
          break;
          case ConnectivityResult.mobile: {
            GlobalSnackBarBloc.showMessage(
              GlobalMsg("Mobile data connection restored", bgColor: Colors.green,),
            );
          }
          break;
          case ConnectivityResult.wifi: {
            GlobalSnackBarBloc.showMessage(
              GlobalMsg("Wi-fi connection restored", bgColor: Colors.green),
            );

          }
          break;
        }
      }
    });
  }

  final themeLight = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
        )
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      elevation: 3
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(
            color: Colors.blue
        ),
        unselectedLabelStyle: TextStyle(
            color: Colors.black
        ),
        selectedIconTheme: IconThemeData(
            color: Colors.blue
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.black,
        )
    ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: Colors.blue,
      secondary: Colors.blue,
    ),
  );

  final themeDark = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        )
    ),
    scaffoldBackgroundColor: HexColor('#1a1a1a'),
    canvasColor: Colors.black,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      color: HexColor('#0f0f0f'),
      elevation: 3
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 1,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: TextStyle(
        color: Colors.blue
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.white
      ),
      selectedIconTheme: IconThemeData(
        color: Colors.blue
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.white,
      )
    ),
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      primary: Colors.blue,
      secondary: Colors.blue,
      onSecondary: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.watch<MainModel>().appName,
      // localization support
      //localizationsDelegates: context.localizationDelegates,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: ThemeMode.system,
      theme: themeLight,
      darkTheme: themeDark,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}





