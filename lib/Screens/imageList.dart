import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperApp/Bloc/favoriBlock.dart';
import 'package:wallpaperApp/Class/builClass.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';
import 'package:wallpaperApp/Models/wallpaper.dart';
import 'package:wallpaperApp/Screens/favoriScreen.dart';
import 'package:wallpaperApp/Screens/searchPage.dart';
import 'package:wallpaperApp/Service/network.dart';

class ImageList extends StatefulWidget {
  ImageList({Key key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> with Navigation, BuildClass {
  Network network = Network();
  ScrollController controller;
  ScrollController controller2;
  String image_type = "all";
  bool editorsChoice=false;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller2 = ScrollController();
    pageController=PageController();
  }

  @override
  Widget build(BuildContext context) {
    final _favBloc=Provider.of<FavoriBlock>(context);
    return Scaffold(
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        controller: controller2,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("H~WallPaper",style: TextStyle(color: Colors.red),),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search,color: Colors.red,),
                  onPressed: () {
                
                    navigation(context, SearchPage());
                  }),
              IconButton(
                  icon: Icon(Icons.favorite_border,color: Colors.red,),
                  onPressed: () {
                
                    navigation(context, Favourites());
                  }),
              StreamBuilder<bool>(
                stream:_favBloc.quality,
                initialData: false,
                builder: (context,q) {
                  return PopupMenuButton(
                    icon: Icon(Icons.more_vert,color: Colors.red,),
                    initialValue: image_type,
                    itemBuilder: (c) => [
                      PopupMenuItem(
                        child: ListTile(
                          dense: true,
                          title: Text("Resim tipi seç"),
                          trailing: Icon(Icons.arrow_right),
                          onTap: (){
                            RelativeRect position=getPosition(context);
                            Navigator.pop(context);
                            showMenu(context:context, position:position, items:getImageTypeItems());
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:ListTile(
                          dense: true,
                          title: Text("Görüntü kalitesi"),
                          trailing: Icon(Icons.arrow_right),
                          onTap: (){
                            RelativeRect position=getPosition(context);
                            Navigator.pop(context);
                            showMenu(context:context, position:position, items:getImageQuality(q.data,_favBloc));
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child:RadioListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text("Editörün seçimi"),
                          value:true, groupValue:editorsChoice, onChanged:(v){
                            setState(()=>editorsChoice=v);
                            Navigator.pop(context);
                          }),
                      ),
                    ],
                  );
                }
              ),
            ],
            backgroundColor: Colors.white,
          ),
        ],
        body: PageView(
          controller: pageController,
          children: <Widget>[
            FutureBuilder<Wallpaper>(
          key: GlobalKey(),
          future: network.getData(imageType: image_type,editorsChoice:editorsChoice),
          builder: (BuildContext context, AsyncSnapshot<Wallpaper> wal) {
            if (wal.hasData) {
              return StreamBuilder<bool>(
                initialData: false,
                stream: _favBloc.quality,
                builder: (c,q)=>buildStaggeredGridView(wal.data.hits,_favBloc,q.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
            FutureBuilder<Wallpaper>(
          key: GlobalKey(),
          future: network.getData(imageType: image_type,editorsChoice:editorsChoice,order:"latest"),
          builder: (BuildContext context, AsyncSnapshot<Wallpaper> wal) {
            if (wal.hasData) {
              return StreamBuilder<bool>(
                initialData: false,
                stream: _favBloc.quality,
                builder: (c,q)=>buildStaggeredGridView(wal.data.hits,_favBloc,q.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
          ],
        ),
      ),
    );
  }


  List<PopupMenuItem> getImageQuality(bool value,FavoriBlock fav) {
    return [
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text("Düşük"),
              value:false,
              groupValue:value,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  fav.quality.add(false);
                });
              })),
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              title: Text("Yüksek"),
              controlAffinity: ListTileControlAffinity.trailing,
              value:true,
              groupValue:value,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  fav.quality.add(true);
                });
              })),
    ];
  }
  List<PopupMenuItem> getImageTypeItems() {
    return [
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text("Resim"),
              value: image_type != "photo",
              groupValue:false,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  image_type = "photo";
                });
              })),
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              title: Text("Çizim"),
              controlAffinity: ListTileControlAffinity.trailing,
              value: image_type != "illustration",
              groupValue:false,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  print(v);
                  image_type = "illustration";
                });
              })),
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              title: Text("Vektör"),
              controlAffinity: ListTileControlAffinity.trailing,
              value: image_type != "vector",
              groupValue:false,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  print(v);
                  image_type = "vector";
                });
              })),
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              title: Text("Hepsi"),
              controlAffinity: ListTileControlAffinity.trailing,
              value: image_type != "all",
              groupValue:false,
              onChanged: (v) {
                Navigator.pop(context);
                setState(() {
                  image_type = "all";
                });
              })),
    ];
  }
  RelativeRect getPosition(BuildContext context){
    Size size=MediaQuery.of(context).size;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position =  RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // RelativeRect.fromLTRB(size.width,MediaQuery.of(context).padding.top,20,size.height);
    return position;
  }
}
