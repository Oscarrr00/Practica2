import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shazam/favorites_page.dart';
import 'package:shazam/main_page.dart';
import 'package:shazam/provider/provider_music.dart';

class ButtonFavorite extends StatelessWidget {
  final Map<String, dynamic>? artist;
  final bool checked_favorite;
  const ButtonFavorite({
    Key? key,
    required this.artist,
    required this.checked_favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _eliminar() async {
      context.read<Provide_Music>().eliminar(artist!);
    }

    Future<void> _addFavorite() async {
      context.read<Provide_Music>().addFavorite(artist!);
    }

    ;
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eliminar de Favoritos'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'El elemento sera eliminado de tus favoritos ¿Quieres continuar?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Eliminar'),
                onPressed: () {
                  _eliminar();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "La cancion fue eliminada de tus favoritos",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MainPage(context2: context),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return IconButton(
      onPressed: () {
        if (checked_favorite) {
          _showMyDialog();
        } else {
          _addFavorite();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "La cancion fue agregada a tus favoritos",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ));
        }
      },
      color: (checked_favorite) ? Colors.white : Colors.black,
      icon: Icon(Icons.favorite),
    );
  }
}
