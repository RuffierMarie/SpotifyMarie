import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/models/artiste.dart';
import 'package:projet_spotify_gorouter/provider.dart';
import 'package:projet_spotify_gorouter/models/chanson.dart';

class ArtisteDetailScreen extends StatefulWidget {
  final String artistId;

  const ArtisteDetailScreen({Key? key, required this.artistId}) : super(key: key);

  @override
  _ArtisteDetailScreenState createState() => _ArtisteDetailScreenState();
}

class _ArtisteDetailScreenState extends State<ArtisteDetailScreen> {
  late Future<List<Chanson>> _topTracksFuture;
  late Future<Artiste> _artistFuture;

  @override
  void initState() {
    super.initState();
    _artistFuture = SpotifyProvider().fetchArtistDetails(widget.artistId);
    _topTracksFuture = SpotifyProvider().fetchTopTracks(widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artiste')),
      bottomNavigationBar: BottomAppBar(
    child: ElevatedButton(
      onPressed: () => context.go('/a'),
      child: const Text('Go back'),
    ),
  ),
      body: FutureBuilder<Artiste>(
        future: _artistFuture,
        builder: (context, artistSnapshot) {
          if (artistSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (artistSnapshot.hasError) {
            return Center(child: Text('Error: ${artistSnapshot.error}'));
          } else if (artistSnapshot.hasData && artistSnapshot.data != null) {
            final artist = artistSnapshot.data!;
            return FutureBuilder<List<Chanson>>(
              future: _topTracksFuture,
              builder: (context, tracksSnapshot) {
                if (tracksSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (tracksSnapshot.hasError) {
                  return Center(child: Text('Error: ${tracksSnapshot.error}'));
                } else if (tracksSnapshot.hasData && tracksSnapshot.data != null) {
                  final List<Chanson> topTracks = tracksSnapshot.data!.take(5).toList();
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(artist.name ?? 'Unknown', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        if (artist.imageUrl != null)
                          Image.network(
                            artist.imageUrl!,
                            width: 200,
                            height: 200,
                          ),
                        Text('Top 5 des titres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: topTracks.length,
                          itemBuilder: (context, index) {
                            final Chanson track = topTracks[index];
                            return ListTile(
                              title: Text(track.name ?? ''),
                             onTap: () {
                                SpotifyProvider().fetchChansonDetails(track.id!).then((chanson) {
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
                  return Center(child: Text('Top tracks not found'));
                }
              },
            );
          } else {
            return Center(child: Text('Artist not found'));
          }
        },
      ),
    );
  }
}
