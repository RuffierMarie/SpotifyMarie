import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart'; 
import 'package:projet_spotify_gorouter/models/album.dart';
import 'package:projet_spotify_gorouter/models/chanson.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId; 

  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late Future<Album> _albumFuture;

  @override
  void initState() {
    super.initState();
    _albumFuture = SpotifyProvider().fetchAlbumDetails(widget.albumId);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Album')),
    bottomNavigationBar: BottomAppBar(
    child: ElevatedButton(
      onPressed: () => context.go('/a'),
      child: const Text('Go back'),
    ),
  ),
    body: FutureBuilder<Album>(
      future: _albumFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final album = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  album.name ?? 'Unknown',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (album.imageUrl != null && album.imageUrl!.isNotEmpty)
                  Image.network(
                    album.imageUrl ?? '',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Artiste(s):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: album.artiste?.length ?? 0,
                  itemBuilder: (context, index) {
                    final artist = album.artiste![index];
                    return ListTile(
                      title: Text(artist.name ?? ''),
                      onTap: () {
                        context.go('/a/artistedetails/${artist.id}');
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chansons de l\'album',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                  ListView.builder(
                  shrinkWrap: true,
                  itemCount: album.chansons?.length ?? 0,
                  itemBuilder: (context, index) {
                    final song = album.chansons![index];
                      return ListTile(
                        title: Text(song.name ?? ''),
                        onTap: () {
                          SpotifyProvider().fetchChansonDetails(song.id!).then((chanson) {
                            context.go('/a/chansondetails/${chanson.id}');
                          }).catchError((error) {
                            print('Error fetching chanson details: $error');
                          });
                        },
                      );
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('Album not found'));
        }
      },
    ),
  );
}


}
