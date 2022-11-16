import 'package:flutter/material.dart';
import 'package:shazam/Items/button_favorite.dart';
import 'package:shazam/Items/icons_links.dart';

class DetallesArtist extends StatelessWidget {
  final Map<String, dynamic> Element;
  final bool checked_favorite;
  const DetallesArtist({
    Key? key,
    required this.Element,
    required this.checked_favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text("Here you go"),
              ButtonFavorite(
                  artist: Element, checked_favorite: checked_favorite),
            ])),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network("${Element["image"]}"),
            Column(
              children: [
                Text(
                  "${Element["title"]}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${Element["album"]}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${Element["artist"]}",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "${Element["release_date"]}",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text("Abrir con:"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconsLink(
                        image: "assets/images/spotify.png",
                        link: "${Element["spotify"]}",
                        tooltip: "Ver en Spotify"),
                    IconsLink(
                        icon: Icons.podcasts,
                        link: "${Element["song_link"]}",
                        tooltip: "Ver en Podcast"),
                    IconsLink(
                        icon: Icons.apple_outlined,
                        link: "${Element["apple_music"]}",
                        tooltip: "Ver en Apple Music"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}
