import 'package:flutter/material.dart';

class MyGridView extends StatefulWidget {
  final List<Widget> children;
  final int axisCount;
  const MyGridView({Key? key, required this.children, this.axisCount = 2})
      : super(key: key);

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  List<List<Widget>> widgets = [];

  List<List<Widget>> childrenLists(List<Widget> children) {
    List<List<Widget>> widgets = [];

    for (int a = 0; a < widget.axisCount; a++) {
      widgets.add([]);
    }

    for (int i = 0; i < children.length; i++) {
      for (int a = 0; a < widget.axisCount; a++) {
        if (i % widget.axisCount == a) {
          widgets[a].add(children[i]);
          break;
        }
      }
    }
    return widgets;
  }

  @override
  void initState() {
    widgets = childrenLists(widget.children);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.axisCount; i++)
              SizedBox(
                width: (size.width - 12) / widget.axisCount,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widgets[i],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
