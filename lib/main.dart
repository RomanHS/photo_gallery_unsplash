import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts.dart' as consts;
import 'data.dart';

void main() => runApp(PhotoGalleryUnsplash());

class PhotoGalleryUnsplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Body(),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var res = context.watch<Data>().getStatusCode;

    if (res == null) {
      context.read<Data>().httpRequest();
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (res == 0) {
      context.read<Data>().httpRequest();
      return Center(
        child: Text(consts.noInternetAccess),
      );
    } else if (res == 200) {
      return ListView(
        children: listView(context.watch<Data>().getJson, context),
      );
    } else {
      context.read<Data>().httpRequest();
      return Center(
        child: Text(consts.error + res.toString()),
      );
    }
  }

  List<Widget> listView(List<dynamic> json, BuildContext context) {
    List<Widget> tempListWidgets = [];

    for (var e in json) {
      tempListWidgets.add(
        ListTile(
          leading: Image.network(
            e['urls']['thumb'],
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return CircularProgressIndicator();
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Text(consts.error);
            },
          ),
          title: Text(e['id']),
          subtitle: Text(e['user']['name']),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenImg(e['urls']['full']))),
        ),
      );
    }
    return tempListWidgets;
  }
}

class ScreenImg extends StatelessWidget {
  final String _url;
  ScreenImg(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            child: Image.network(
              _url,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return CircularProgressIndicator();
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Text(consts.error);
              },
            ),
          ),
        ),
      ),
    );
  }
}
