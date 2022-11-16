import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shazam/Items/item_artist.dart';
import 'package:shazam/provider/provider_music.dart';

class FavoritePage extends StatelessWidget {
  final Elements;
  FavoritePage({
    Key? key,
    this.Elements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: (Elements.length >= 0)
          ? Container(
              height: MediaQuery.of(context).size.height / 1,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: Elements.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemArtist(artist: Elements[index]);
                },
              ),
            )
          : Container(),
    );
  }
}
