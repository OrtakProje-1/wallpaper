import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperApp/Class/builClass.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';
import 'package:wallpaperApp/Models/downloadTask.dart';
import 'package:wallpaperApp/Models/favoriImage.dart';
import 'package:wallpaperApp/Models/hits.dart';
import 'package:wallpaperApp/Service/downloader.dart';
import 'package:built_collection/src/list.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class ImageDetails extends StatefulWidget {
  final BuiltList<Hits> hits;
  final int index;
  final favBloc;
  final bool quality;
  ImageDetails({Key key, this.hits, this.index, this.favBloc,this.quality=false})
      : super(key: key);

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
                   widget.quality?widget.hits[i].largeImageURL:widget.hits[i].previewURL,
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
                    actions: [
                      StreamBuilder<List<FavoriImage>>(
                        stream: widget.favBloc.favStream,
                        initialData: [],
                        builder: (c, images) {
                          if (images.hasData) {
                            bool isfav = false;
                            for (var i in images.data) {
                              if (i.id == widget.hits[index].id) {
                                isfav = true;
                                break;
                              }
                            }
                            return IconButton(
                                icon: Icon(
                                  isfav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isfav ? Colors.red : Colors.black87,
                                ),
                                onPressed: () {
                                  if (isfav) {
                                    widget.favBloc.removeFavourites(
                                        widget.hits[index].id);
                                  } else {
                                    widget.favBloc
                                        .addFavourites(widget.hits[index]);
                                  }
                                });
                          } else {
                            return Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            );
                          }
                        },
                      ),
                    ],
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
                              var request=await HttpClient().getUrl(Uri.parse(widget.hits[widget.index].largeImageURL));
                              var response=await request.close();
                              Uint8List bytes=await consolidateHttpClientResponseBytes(response);
                              Share.file("Paylaşmak istediğin platformu seç","image.jpg", bytes,"image/jpg",text:"H~Wallpaper ile bulduğum bu resim hoşuna gidecek\nHemen sende indir \nAndroid: Çok yakında\nIos: Çok yakında");
                          // await FlutterShare.share(
                          //     title: 'Fotoğraf',
                          //     text: 'H~Wallpaper ile bulduğum bu resim hoşuna gidecek',
                          //     linkUrl:widget.hits[widget.index].largeImageURL,
                          //     chooserTitle: 'Seçiniz');

                          // Share.share("H~Wallpaper ile bulduğum bu resim hoşuna gidecek",subject:widget.hits[widget.index].largeImageURL);
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
