import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:wallpaper/Bloc/favoriBlock.dart';
import 'package:wallpaper/Class/builClass.dart';
import 'package:wallpaper/Constant/navigationConstant.dart';
import 'package:wallpaper/Models/downloadTask.dart';
import 'package:wallpaper/Models/favoriImage.dart';
import 'package:wallpaper/Models/hit.dart';
import 'package:wallpaper/Service/downloader.dart';

class ImageDetailEdited extends StatefulWidget {
  final List<Hit>? hits;
  final int? index;
  final favBloc;
  final bool quality;
  ImageDetailEdited(
      {Key? key, this.hits, this.index, this.favBloc, this.quality = false})
      : super(key: key);

  @override
  _ImageDetailEditedState createState() => _ImageDetailEditedState();
}

class _ImageDetailEditedState extends State<ImageDetailEdited>
    with Navigation, BuildClass {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Downloader downloader = Downloader();
  bool isOpacity = true;
  PageController? _controller;
  int? index;

  @override
  initState() {
    super.initState();
    index = widget.index;
    _controller = PageController(initialPage: index!);
  }

  showSnack(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mesaj),
        duration: Duration(milliseconds: 2000),
        action: SnackBarAction(label: "Tamam", onPressed: () {})));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FavoriBlock block = Provider.of<FavoriBlock>(context);
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
              itemCount: widget.hits!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) => Hero(
                tag: widget.hits![i].id!,
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Image.network(
                    widget.quality
                        ? widget.hits![i].largeImageURL!
                        : widget.hits![i].previewURL!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              left: 12,
              top: MediaQuery.of(context).padding.top + 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myIconButton(
                    Icons.arrow_back_ios_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  StreamBuilder<List<Hit>>(
                      stream: block.favStream,
                      initialData: block.favoriImages,
                      builder: (context, snapshot) {
                        bool isFavoriteHit =
                            snapshot.data!.contains(widget.hits![index!]);
                        return myIconButton(
                          Icons.favorite_border_rounded,
                          onPressed: () {
                            if (isFavoriteHit) {
                              widget.favBloc
                                  .removeFavourites(widget.hits![index!].id);
                            } else {
                              widget.favBloc
                                  .addFavourites(widget.hits![index!]);
                            }
                          },
                        );
                      }),
                ],
              ),
            ),
            Positioned(
              right: 12,
              left: 12,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myIconButton(
                    Icons.wallpaper_rounded,
                    onPressed: () async {
                      int? screen = await buildSelectWallpaper(context);
                      if (screen != 0) {
                        buildPleaseWaitAlert(context);
                        bool result =
                            await downloader.chachDownloadandSetWallpaper(
                                widget.hits![index!].largeImageURL, screen);
                        showSnack(result
                            ? "Duvar kağıdı değiştirildi"
                            : "Üzgünüm! Bir hata oluştu");
                        Navigator.pop(context);
                      }
                    },
                  ),
                  myIconButton(
                    Icons.download_rounded,
                    onPressed: () async {
                      Task newTask = Task(
                          link: widget.hits![index!].largeImageURL,
                          name:
                              DateTime.now().millisecondsSinceEpoch.toString());
                      bool sonuc = await downloader.download(newTask);
                      if (!sonuc) {
                        showSnack("İndirme başlatılamadı");
                      } else {
                        showSnack("indirme başladı");
                      }
                    },
                  ),
                  myIconButton(
                    Icons.share,
                    onPressed: () async {
                      var request = await HttpClient().getUrl(Uri.parse(
                          widget.hits![widget.index!].largeImageURL!));
                      var response = await request.close();
                      Uint8List bytes =
                          await consolidateHttpClientResponseBytes(response);
                      getTemporaryDirectory().then((value) async {
                        File temp = File(value.path + "/temp.jpg");
                        File newFile = await temp.writeAsBytes(bytes);
                        Share.shareFiles([newFile.path],
                            mimeTypes: ["image/jpg"],
                            text:
                                "H~Wallpaper ile bulduğum bu resim hoşuna gidecek\nHemen sende indir \nAndroid: Çok yakında\nIos: Çok yakında");
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myIconButton(IconData icon, {VoidCallback? onPressed}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 24,
        ),
        onPressed: onPressed,
        color: Colors.white,
      ),
    );
  }
}
