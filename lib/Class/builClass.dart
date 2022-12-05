import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/Bloc/favoriBlock.dart';
import 'package:wallpaper/Constant/navigationConstant.dart';
import 'package:wallpaper/Models/hit.dart';
import 'package:wallpaper/Pages/image_details_edited.dart';
import 'package:wallpaper/Screens/imageDetails.dart';
import 'package:wallpaper/Widgets/my_grid_view.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

mixin BuildClass implements Navigation {
  Widget buildStaggeredGridView(
      BuildContext context, List<Hit> hits, FavoriBlock bloc, bool? quality) {
    return MyGridView(
      axisCount: 2,
      children: hits.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: buildImage(context, hits, hits.indexOf(e), bloc, quality!),
        );
      }).toList(),
    );
  }

  Widget buildImage(
      BuildContext c, List<Hit> h, int index, FavoriBlock bloc, bool quality) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            radius: 15,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              navigation(
                  c,
                  ImageDetailEdited(
                      favBloc: bloc, hits: h, index: index, quality: quality));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade600,
                      blurRadius: 5,
                      offset: Offset(-2, 3)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: h[index].id!,
                  child: CachedNetworkImage(
                    imageUrl: quality
                        ? h[index].largeImageURL!
                        : h[index].previewURL!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, child, loadingProgress) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        color: Colors.transparent,
                        child: Center(
                          child: Transform.scale(
                            scale: 0.7,
                            child: CircularProgressIndicator(
                              value: loadingProgress.progress != null
                                  ? loadingProgress.progress!
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Text("Hata");
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(Icon icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          icon,
          Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  void buildPleaseWaitAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("Lütfen bekleyiniz!!"),
            ],
          ),
        );
      },
    );
  }

  Future<int?> buildSelectWallpaper(BuildContext context) async {
    int? screen = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Theme(
            data: ThemeData.dark(),
            child: AlertDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Lütfen Birini seçiniz",
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(height: 1),
                  ListTile(
                      dense: true,
                      title: Text("Ana ekran"),
                      onTap: () => Navigator.pop(
                          context, WallpaperManagerFlutter.HOME_SCREEN)),
                  ListTile(
                      dense: true,
                      title: Text("Kilit ekranı"),
                      onTap: () => Navigator.pop(
                          context, WallpaperManagerFlutter.LOCK_SCREEN)),
                  ListTile(
                      dense: true,
                      title: Text("Ana/Kilit ekran"),
                      onTap: () => Navigator.pop(
                          context, WallpaperManagerFlutter.BOTH_SCREENS)),
                ],
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                  child: Text("İptal et"),
                ),
              ],
            ),
          );
        });
    print(screen);
    return screen;
  }
}
