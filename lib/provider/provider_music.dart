import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shazam/clases/request_http.dart';

class Provide_Music with ChangeNotifier {
  final record = Record();
  List<Map<String, dynamic>>? Elements;
  String? path;
  var requestHttp = new RequestHttp();
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  bool glow = false;

  void addFavorite(Map<String, dynamic> song) async {
    var user = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var favorite_song = user.collection("favoriteSongs");
    await favorite_song.add(song);
    // if (Elements == null) {
    //   Elements = [];
    // }
    // Elements?.add(song);
    notifyListeners();
  }

  Future<bool> check_favorite(Map<String, dynamic> song) async {
    var user = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    QuerySnapshot<Map<String, dynamic>> songs_query =
        await user.collection("favoriteSongs").get();

    var favoriteSongs = songs_query.docs
        .map((song) => {
              "image": song["image"],
              "title": song["title"],
              "album": song["album"],
              "artist": song["artist"],
              "release_date": song["release_date"],
              "spotify": song["spotify"],
              "song_link": song["song_link"],
              "apple_music": song["apple_music"],
            })
        .toList();

    if (favoriteSongs.length <= 0) {
      return false;
    } else {
      for (int i = 0; i < favoriteSongs.length; i++) {
        Map<String, dynamic> favoriteSong = favoriteSongs[i];
        if (favoriteSong["title"] == song["title"]) {
          return true;
        }
      }
      return false;
    }
  }

  void eliminar(Map<String, dynamic> artist) async {
    var user = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    QuerySnapshot<Map<String, dynamic>> songs_query =
        await user.collection("favoriteSongs").get();

    for (var doc in songs_query.docs) {
      if (doc["title"] == artist["title"]) {
        await doc.reference.delete();
      }
    }

    notifyListeners();
  }

  void escuchando_glow() {
    glow = true;
    notifyListeners();
  }

  void dejo_de_escuchar_glow() {
    glow = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> escuchar() async {
    Directory? filepath = await getExternalStorageDirectory();

    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '${filepath?.path}/${DateTime.now().millisecondsSinceEpoch}.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
    bool isRecording = await record.isRecording();
    if (isRecording) {
      await Future.delayed(Duration(seconds: 9), stop_record);
    }
    final path = await record.stop();
    File songFile = File(path!);
    Uint8List fileInBytes = songFile.readAsBytesSync();
    String base64String = base64Encode(fileInBytes);
    await dotenv.load();
    String? API_key = dotenv.env['API_KEY'];
    return await requestHttp.post_request(base64String, API_key);
  }

  void stop_record() async {
    path = await record.stop();
  }

  Map<String, String> get_song_map(Map<String, dynamic> song) {
    Map<String, dynamic> spotify = song["spotify"];
    Map<String, dynamic> album = spotify["album"];
    List<dynamic> images = album["images"];
    Map<String, dynamic> apple_music = song["apple_music"];
    Map<String, dynamic> url = spotify["external_urls"];

    Map<String, String> estructuredSong = {
      "image": images[0]["url"],
      "title": song["title"],
      "album": song["album"],
      "artist": song["artist"],
      "release_date": song["release_date"],
      "spotify": url["spotify"],
      "song_link": song["song_link"],
      "apple_music": apple_music["url"],
    };
    return estructuredSong;
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }

    await _createUserCollectionFirebase(FirebaseAuth.instance.currentUser!.uid);

    notifyListeners();
  }

  Future<void> _createUserCollectionFirebase(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    // Si no exite el doc, lo crea con valor default lista vacia
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection("user").doc(uid).set(
        {},
      );
    } else {
      // Si ya existe el doc return
      return;
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    var user = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    QuerySnapshot<Map<String, dynamic>> songs_query =
        await user.collection("favoriteSongs").get();

    var favoriteSongs = songs_query.docs
        .map((song) => {
              "image": song["image"],
              "title": song["title"],
              "album": song["album"],
              "artist": song["artist"],
              "release_date": song["release_date"],
              "spotify": song["spotify"],
              "song_link": song["song_link"],
              "apple_music": song["apple_music"],
            })
        .toList();
    return favoriteSongs;
  }
}
