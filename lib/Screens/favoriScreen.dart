import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperApp/Bloc/favoriBlock.dart';
import 'package:wallpaperApp/Class/builClass.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';
import 'package:wallpaperApp/Models/downloadTask.dart';
import 'package:wallpaperApp/Models/favoriImage.dart';
import 'package:wallpaperApp/Service/downloader.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class Favourites extends StatefulWidget {
  Favourites({Key key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> with Navigation {
  @override
  Widget build(BuildContext context) {
    final _favBloc = Provider.of<FavoriBlock>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (c, b) => [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.red),
            title: Text(
              "Favorilerim",
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: true,
          ),
        ],
        body: StreamBuilder<List<FavoriImage>>(
          stream: _favBloc.favStream,
          initialData: [],
          builder: (c, hits) {
            if (hits.hasData) {
              return buildStaggeredGridView(hits.data, _favBloc);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  StaggeredGridView buildStaggeredGridView(
      List<FavoriImage> hits, FavoriBlock bloc) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(4),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      addAutomaticKeepAlives: true,
      crossAxisCount: 4,
      itemCount: hits.length,
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 4 : 3),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemBuilder: (BuildContext context, int index) =>
          buildImage(context, hits, index, bloc),
    );
  }

  Widget buildImage(
      BuildContext c, List<FavoriImage> h, int index, FavoriBlock bloc) {
    return InkWell(
      radius: 15,
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        navigation(
            c,
            ImageDetails(
              hits: h,
              index: index,
            ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Hero(
          tag: h[index].id,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: 0,
                child: Image.network(
                  h[index].previewURL,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.white24,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white70),
                    child: IconButton(
                        color: Colors.white,
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          bloc.removeFavourites(h[index].id);
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDetails extends StatefulWidget {
  final List<FavoriImage> hits;
  final int index;
  ImageDetails({Key key, this.hits, this.index}) : super(key: key);

  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails>
    with Navigation, BuildClass {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Downloader downloader = Downloader();
  bool isOpacity = true;
  PageController _controller;
  int index;

  @override
  initState() {
    super.initState();
    index = widget.index;
    _controller = PageController(initialPage: index);
  }

  showSnack(String mesaj) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(mesaj),
        duration: Duration(milliseconds: 2000),
        action: SnackBarAction(label: "Tamam", onPressed: () {})));
  }

  @override
  Widget build(BuildContext context) {
    List<Icon> icons = [
      Icon(
        Icons.favorite_border,
        color: Colors.white,
      ),
      Icon(
        Icons.cloud_download,
        color: Colors.white,
      ),
      Icon(
        Icons.grade,
        color: Colors.white,
      ),
      Icon(
        Icons.visibility,
        color: Colors.white,
      )
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: InkWell(
        onTap: () {
          setState(() {
            isOpacity = !isOpacity;
          });
        },
        child: Stack(
          children: <Widget>[
            PageView.builder(
              onPageChanged: (i) {
                setState(() {
                  index = i;
                });
              },
              controller: _controller,
              itemCount: widget.hits.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) => Hero(
                tag: widget.hits[i].id,
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Image.network(
                    widget.hits[i].previewURL,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: isOpacity
                  ? 0
                  : -(AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top),
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isOpacity ? 1 : 0,
                child: Container(
                  height: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top,
                  width: size.width,
                  child: AppBar(
                    iconTheme: IconThemeData(color: Colors.red),
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    title: Text(
                      "Resim",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              bottom: isOpacity ? 0 : -60,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isOpacity ? 1 : 0,
                child: Container(
                  width: double.maxFinite,
                  height: 60,
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildButton(
                            Icon(
                              Icons.wallpaper,
                              color: Colors.red,
                            ),
                            "Duvar Kağıdı Yap", onTap: () async {
                          int screen = await buildSelectWallpaper(context);
                          if (screen != 0) {
                            buildPleaseWaitAlert(context);
                            bool result =
                                await downloader.chachDownloadandSetWallpaper(
                                    widget.hits[index].largeImageURL, screen);
                            showSnack(result
                                ? "Duvar kağıdı değiştirildi"
                                : "Üzgünüm! Bir hata oluştu");
                            Navigator.pop(context);
                          }
                        }),
                        buildButton(
                            Icon(Icons.cloud_download, color: Colors.red),
                            "İndir", onTap: () async {
                          Task newTask = Task(
                              link: widget.hits[index].largeImageURL,
                              name: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());
                          bool sonuc = await downloader.download(newTask);
                          if (!sonuc) {
                            showSnack("İndirme başlatılamadı");
                          } else {
                            showSnack("indirme başladı");
                          }
                        }),
                        buildButton(
                            Icon(Icons.share, color: Colors.red), "Paylaş",
                            onTap: () async {
                          var request = await HttpClient().getUrl(Uri.parse(
                              widget.hits[widget.index].largeImageURL));
                          var response = await request.close();
                          Uint8List bytes =
                              await consolidateHttpClientResponseBytes(
                                  response);
                          Share.file(
                              "Paylaşmak istediğin platformu seç", "image.jpg", bytes, "image/jpg",
                              text:
                                  "H~Wallpaper ile bulduğum bu resim hoşuna gidecek\nHemen sende indir \nAndroid: Çok yakında\nIos: Çok yakında");

                          // await FlutterShare.share(
                          // title: 'Fotoğraf',
                          // text: 'H~Wallpaper ile bulduğum bu resim hoşuna gidecek',
                          // linkUrl:widget.hits[widget.index].largeImageURL,
                          // chooserTitle: 'Example Chooser Title');
                          //  Share.share(widget.hits[widget.index].largeImageURL,subject:"H~Wallpaper ile bulduğum bu resim hoşuna gidecek");
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              left: 0,
              right: 0,
              bottom: isOpacity ? 60 : -100,
              duration: Duration(milliseconds: 400),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                height: 40,
                color: Colors.white,
                width: size.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [1, 2, 3, 4]
                        .map((e) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.red.withOpacity(0.8),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    icons[e - 1],
                                    SizedBox(
                                      width: 6,
                                    ),
                                    if (e == 1)
                                      Text(
                                        widget.hits[index].favorites.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (e == 2)
                                      Text(
                                        widget.hits[index].downloads.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (e == 3)
                                      Text(
                                        widget.hits[index].likes.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    if (e == 4)
                                      Text(
                                        widget.hits[index].views.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
