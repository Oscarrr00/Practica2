import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:provider/provider.dart';
import 'package:shazam/detalles_page.dart';
import 'package:shazam/favorites_page.dart';
import 'package:shazam/provider/provider_music.dart';

class MainPage extends StatelessWidget {
  final BuildContext context2;
  MainPage({
    Key? key,
    required this.context2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool glow = context2.watch<Provide_Music>().glow;
    Map<String, dynamic> song;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 25),
            (glow)
                ? Text("Escuchando.....", style: TextStyle(fontSize: 19))
                : Text("Toque para escuchar", style: TextStyle(fontSize: 19)),
            SizedBox(height: 30),
            AvatarGlow(
              glowColor: Colors.red,
              animate: glow,
              endRadius: 180.0,
              child: GestureDetector(
                onTap: () async {
                  context.read<Provide_Music>().escuchando_glow();
                  song = await context.read<Provide_Music>().escuchar();
                  context.read<Provide_Music>().dejo_de_escuchar_glow();
                  if (song["result"] == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "La cancion no fue encontrada, intente de nuevo",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ));
                  } else {
                    bool checked_favorite = await context
                        .read<Provide_Music>()
                        .check_favorite(song["result"]);
                    var song_mapped = context
                        .read<Provide_Music>()
                        .get_song_map(song["result"]);
                    print(song_mapped);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetallesArtist(
                            Element: song_mapped,
                            checked_favorite: checked_favorite),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/images/music_icon.png',
                    height: 110,
                    width: 110,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    hoverColor: Colors.grey[100],
                    focusColor: Colors.grey[100],
                    onPressed: () async {
                      var Elements = await context
                          .read<Provide_Music>()
                          .getFavoriteSongs();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              FavoritePage(Elements: Elements),
                        ),
                      );
                    },
                    icon: Icon(Icons.favorite),
                    tooltip: "Ver favoritos",
                  ),
                ),
                SizedBox(width: 20),
                CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    hoverColor: Colors.grey[100],
                    focusColor: Colors.grey[100],
                    onPressed: () {
                      context.read<Provide_Music>().logout();
                    },
                    icon: Icon(Icons.logout_rounded),
                    tooltip: "Salir sesion",
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
