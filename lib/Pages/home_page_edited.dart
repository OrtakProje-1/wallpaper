import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/Bloc/favoriBlock.dart';
import 'package:wallpaper/Class/builClass.dart';
import 'package:wallpaper/Constant/navigationConstant.dart';
import 'package:wallpaper/Models/wallpaper.dart';
import 'package:wallpaper/Screens/favoriScreen.dart';
import 'package:wallpaper/Screens/searchPage.dart';
import 'package:wallpaper/Service/network.dart';

class HomePageEdited extends StatefulWidget {
  HomePageEdited({Key? key}) : super(key: key);

  @override
  _HomePageEditedState createState() => _HomePageEditedState();
}

class _HomePageEditedState extends State<HomePageEdited>
    with Navigation, BuildClass {
  Network network = Network();
  ScrollController? controller;
  ScrollController? controller2;
  String image_type = "all";
  bool? editorsChoice = false;
  PageController? pageController;
  Wallpaper? wallpaper;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller2 = ScrollController();
    pageController = PageController();
    getWallpaper();
  }

  void getWallpaper() {
    network
        .getData(
      imageType: image_type,
      editorsChoice: editorsChoice,
    )
        .then(
      (value) {
        setState(() {
          wallpaper = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _favBloc = Provider.of<FavoriBlock>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 12, right: 6, left: 6),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/gradient_1.jpg"))),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: Offset(-2, 2)),
                        ],
                      ),
                      child: Center(
                        child: ListTile(
                          title: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: "Resim ara ...",
                                isCollapsed: true,
                                border: InputBorder.none),
                          ),
                          trailing: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<bool>(
                      stream: _favBloc.quality,
                      initialData: false,
                      builder: (context, q) {
                        return PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 30,
                          ),
                          initialValue: image_type,
                          itemBuilder: (c) => [
                            PopupMenuItem(
                              child: ListTile(
                                dense: true,
                                title: Text("Resim tipi seç"),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () {
                                  RelativeRect position = getPosition(context);
                                  Navigator.pop(context);
                                  showMenu(
                                      context: context,
                                      position: position,
                                      items: getImageTypeItems());
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                dense: true,
                                title: Text("Görüntü kalitesi"),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () {
                                  RelativeRect position = getPosition(context);
                                  Navigator.pop(context);
                                  showMenu(
                                      context: context,
                                      position: position,
                                      items: getImageQuality(q.data, _favBloc));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: RadioListTile(
                                  dense: true,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text("Editörün seçimi"),
                                  value: true,
                                  groupValue: editorsChoice,
                                  onChanged: (dynamic v) {
                                    setState(() => editorsChoice = v);
                                    Navigator.pop(context);
                                  }),
                            ),
                          ],
                        );
                      }),
                ],
              ),
              wallpaper != null
                  ? getPageWidget(_favBloc)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Transform.scale(
                        scaleY: 0.5,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  getPageWidget(FavoriBlock favBloc) {
    return Expanded(
      child: StreamBuilder<bool>(
        initialData: false,
        stream: favBloc.quality,
        builder: (c, q) =>
            buildStaggeredGridView(context, wallpaper!.hits!, favBloc, q.data),
      ),
    );
  }

  List<PopupMenuItem> getImageQuality(bool? value, FavoriBlock fav) {
    return [
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text("Düşük"),
              value: false,
              groupValue: value,
              onChanged: (dynamic v) {
                Navigator.pop(context);
                setState(() {
                  fav.quality!.add(false);
                });
              })),
      PopupMenuItem(
          child: RadioListTile(
              dense: true,
              title: Text("Yüksek"),
              controlAffinity: ListTileControlAffinity.trailing,
              value: true,
              groupValue: value,
              onChanged: (dynamic v) {
                Navigator.pop(context);
                setState(() {
                  fav.quality!.add(true);
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
              groupValue: false,
              onChanged: (dynamic v) {
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
              groupValue: false,
              onChanged: (dynamic v) {
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
              groupValue: false,
              onChanged: (dynamic v) {
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
              groupValue: false,
              onChanged: (dynamic v) {
                Navigator.pop(context);
                setState(() {
                  image_type = "all";
                });
              })),
    ];
  }

  RelativeRect getPosition(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // RelativeRect.fromLTRB(size.width,MediaQuery.of(context).padding.top,20,size.height);
    return position;
  }
}
