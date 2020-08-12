import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperApp/Bloc/favoriBlock.dart';
import 'package:wallpaperApp/Bloc/searchBloc.dart';
import 'package:wallpaperApp/Bloc/searchBloc/searchEvent.dart';
import 'package:wallpaperApp/Bloc/searchBloc/serchState.dart';
import 'package:wallpaperApp/Class/builClass.dart';
import 'package:wallpaperApp/Constant/navigationConstant.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with Navigation, BuildClass {
  TextEditingController searchQuery = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _favBloc=Provider.of<FavoriBlock>(context);
    return Material(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (c, b) => [
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.red),
              floating: true,
              snap: true,
              actions: <Widget>[
                BlocBuilder<SearchBloc, ImageSearchState>(
                  key: GlobalKey(),
              cubit: BlocProvider.of<SearchBloc>(context),
              builder: (BuildContext context, ImageSearchState state) {
                if(!(state is ImageSearchEmpty)){
                  return IconButton(
                  onPressed: () {
                    searchQuery.clear();
                    BlocProvider.of<SearchBloc>(context)
                        .add(ChangeText(searchQuery.text));
                  },
                  icon: Icon(Icons.clear),
                );
                }else return SizedBox();
              },
                ),
              
              ],
              backgroundColor: Colors.white,
              title: TextField(
                style: TextStyle(color: Colors.red.shade500,decoration: TextDecoration.none),
                autocorrect: true,
                cursorColor:Colors.redAccent,
                cursorRadius: Radius.circular(6),
                controller: searchQuery,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Ne aramıştınız?",
                  border: InputBorder.none,
                ),
                onChanged: (s) {
                  print(s);
                  BlocProvider.of<SearchBloc>(context).add(ChangeText(s));
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (a) {
                  BlocProvider.of<SearchBloc>(context).add(SearchText(a));
                  print(a + " on Submit");
                },
              ),
            ),
          ],
          body: BlocBuilder<SearchBloc, ImageSearchState>(
              key: GlobalKey(),
              cubit: BlocProvider.of<SearchBloc>(context),
              builder: (BuildContext context, state) {
              if(state is ImageSearchTextState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.search,size:55,color: Colors.red,),
                        SizedBox(height: 20,),
                        Text("Aramak için klavyedeki arama tuşuna basınız"),
                      ],
                    ),
                  );
                }else if(state is ImageSearchEmptySuccess){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error_outline,size:55,color: Colors.red,),
                        SizedBox(height: 20,),
                        Text("Üzgünüm hiç sonuç bulamadim"),
                      ],
                    ),
                  );
                }else  if (state is ImageSearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ImageSearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.edit,size:55,color: Colors.red,),
                        SizedBox(height:20,),
                        Text("Lütfen birşeyler yaz"),
                      ],
                    ),
                  );
                } else if (state is ImageSearchSuccess) {
                  return StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(4),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    crossAxisCount: 4,
                    itemCount: state.wallpaper.hits.length,
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.count(2, index.isEven ? 4 : 3),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    itemBuilder: (BuildContext context, int index) =>
                        buildImage(context, state.wallpaper.hits,index,_favBloc),
                  );
                } else if (state is ImageSearchError) {
                  return Center(
                    child: Text("Bilinmeyen hata ${state.error}"),
                  );
                }else{
                  return SizedBox();
                }
              }),
        ),
      ),
    );
  }
}
