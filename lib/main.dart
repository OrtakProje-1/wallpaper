import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperApp/Bloc/favoriBlock.dart';
import 'package:wallpaperApp/Bloc/searchBloc.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';
import 'package:wallpaperApp/Screens/imageList.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _favBloc=FavoriBlock();
    return Provider(
      create: (c)=>_favBloc,
          child: BlocProvider(
        create: (c) => SearchBloc(),
        child: MaterialApp(
          theme: ThemeData(
            accentColor: Colors.red.shade500,
            primaryColor: Colors.white
          ),
          title: 'H~WallPaper',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          home: MyHomePage(),
        ),
        key: GlobalKey(),
      ),
      dispose: (c,fav)=>fav.dispose(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Navigation {
  @override
  Widget build(BuildContext context) => ImageList();
}
