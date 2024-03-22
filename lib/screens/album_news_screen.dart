import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart'; // Importez votre fournisseur Spotify
import 'package:projet_spotify_gorouter/models/album.dart'; // Importez votre modèle simplifié d'album

class AlbumNewsScreen extends StatefulWidget {
  const AlbumNewsScreen({Key? key}) : super(key: key);

  @override
  _AlbumNewsScreenState createState() => _AlbumNewsScreenState();
}

class _AlbumNewsScreenState extends State<AlbumNewsScreen> {
  late Future<List<Album>> _futureAlbums; // Modifiez le type ici

  @override
  void initState() {
    super.initState();
    _futureAlbums = SpotifyProvider().fetchNewAlbums(); // Utilisez then() pour récupérer les données
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouveaux albums'),
      ),
      body: FutureBuilder<List<Album>>(
        future: _futureAlbums,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Album> albums = snapshot.data ?? [];
            return ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return ListTile(
                  leading: Image.network(album.imageUrl ?? ''),
                  title: Text(album.name ?? ''),
                  subtitle: Text(album.artiste?.map((e) => e.name).join(', ') ?? ''),
                  onTap: () {
                    context.go('/a/albumdetails/${album.id}');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
