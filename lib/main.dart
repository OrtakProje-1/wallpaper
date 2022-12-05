import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/Bloc/favoriBlock.dart';
import 'package:wallpaper/Bloc/searchBloc.dart';
import 'package:wallpaper/Constant/navigationConstant.dart';
import 'package:wallpaper/Pages/home_page_edited.dart';
import 'package:wallpaper/Screens/imageList.dart';
import 'package:wallpaper/data/favori_datas.dart';

Box<List<String>>? searchBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await favoriHitDatas.initDb();
  await favoriHitDatas.init();
  searchBox = await Hive.openBox<List<String>>("searchBox");
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => SearchBloc(),
      key: GlobalKey(),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        title: 'H~WallPaper',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Navigation {
  @override
  Widget build(BuildContext context) => HomePageEdited();
}
