import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperApp/Bloc/favoriBlock.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';
import 'package:wallpaperApp/Models/hits.dart';
import 'package:wallpaperApp/Screens/imageDetails.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:built_collection/src/list.dart';

mixin BuildClass implements Navigation {

  StaggeredGridView buildStaggeredGridView(BuiltList<Hits> hits,FavoriBlock bloc,bool quality) {
    return StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(4),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              addAutomaticKeepAlives: true,
              crossAxisCount: 4,
              itemCount:hits.length,
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(2, index.isEven ? 4 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemBuilder: (BuildContext context, int index) =>
                  buildImage(context,hits,index,bloc,quality),
            );
  }

  Widget buildImage(BuildContext c, BuiltList<Hits> h,int index,FavoriBlock bloc,bool quality) {
    return InkWell(
      radius: 15,
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        navigation(
            c,
            ImageDetails(
              favBloc: bloc,
              hits:h,
              index: index,
              quality:quality
            ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Hero(
          tag: h[index].id,
          child: Image.network(
           quality?h[index].largeImageURL :h[index].previewURL,
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
      ),
    );
  }

  Widget buildButton(Icon icon, String title, {VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          icon,
          Text(title,style: TextStyle(color: Colors.red),),
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
              SizedBox(width: 10,),
              Text("Lütfen bekleyiniz!!"),
            ],
          ),
        );
      });
  }

  Future<int> buildSelectWallpaper(BuildContext context)async{
   int screen=await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(),
                  child: AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Lütfen Birini seçiniz",style: TextStyle(color: Colors.white60,fontSize: 14),),
                SizedBox(height: 10,),
                Divider(height: 1),
                ListTile(dense:true,title: Text("Ana ekran"),onTap:()=>Navigator.pop(context,WallpaperManager.HOME_SCREEN)),
                ListTile(dense:true,title: Text("Kilit ekranı"),onTap:()=>Navigator.pop(context,WallpaperManager.LOCK_SCREEN)),
                ListTile(dense:true,title: Text("Ana/Kilit ekran"),onTap:()=>Navigator.pop(context,WallpaperManager.BOTH_SCREENS)),
              ],
            ),
            actions: <Widget>[
              OutlineButton(highlightedBorderColor: Colors.teal,shape: StadiumBorder(),onPressed:(){Navigator.pop(context,0);},child:Text("İptal et"),),
            ],
          ),
        );
      });
      print(screen);
      return screen;
  }
}
