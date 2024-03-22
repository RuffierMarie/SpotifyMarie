import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet_spotify_gorouter/models/artiste.dart';
import 'models/album.dart';
import 'models/artiste.dart';
import 'models/chanson.dart';

class SpotifyProvider {
  static const bearer = "Bearer BQDBPyt9gX9I5SN9Lz8PlUKeT3TVJnn7CSfsaVqfoM0i5WFaphmwhxZd080km9G49Smgqvo_Fik5PFjtDXG4oIXurWeEyckcMqUYRbStcj5GzoZltjQ";
  static const String _baseUrl = 'https://api.spotify.com/v1';

  Future<List<Album>> fetchNewAlbums() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/browse/new-releases'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> albumList = responseData['albums']['items'];
    final List<Album> albums = albumList
        .map((albumJson) => Album.fromJson(albumJson))
        .toList();
    return albums;
  } else {
    throw Exception('Failed to load new albums');
  }
}

Future<Album> fetchAlbumDetails(String albumId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/albums/$albumId'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final Album album = Album.fromJson(responseData);

    return album;
  } else {
    throw Exception('Failed to load album details');
  }
}

Future<Artiste> fetchArtistDetails(String artistId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/artists/$artistId'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final Artiste artiste = Artiste.fromJson(responseData);
    return artiste;
  } else {
    throw Exception('Failed to load artist details');
  }
}

Future<List<Chanson>> fetchTopTracks(String artistId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/artists/$artistId/top-tracks?market=FR'), 
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body)['tracks'];
    final List<Chanson> topTracks = responseData.map((trackJson) => Chanson.fromJson(trackJson)).toList();
    return topTracks;
  } else {
    throw Exception('Failed to load top tracks for artist');
  }
}

Future<Chanson> fetchChansonDetails(String chansonId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/tracks/$chansonId'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final Chanson chanson = Chanson.fromJson(responseData);
    return chanson;
  } else {
    throw Exception('Failed to load artist details');
  }
}

Future<List<Album>> searchAlbums(String query) async {
  final String url = 'https://api.spotify.com/v1/search?type=album&market=FR&q=$query';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': bearer,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> albumList = responseData['albums']['items'];
    final List<Album> albums = albumList
        .map((albumJson) => Album.fromJson(albumJson))
        .toList();
    return albums;
  } else {
    throw Exception('Failed to search albums');
  }
}

}
