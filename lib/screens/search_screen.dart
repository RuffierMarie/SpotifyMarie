import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/provider.dart';
import 'package:projet_spotify_gorouter/models/album.dart'; // Importez votre provider

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Album> _searchResults = [];

  void _performSearch(String query) async {
    try {
      List<Album> results = await SpotifyProvider().searchAlbums(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching albums: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un album',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    String query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      _performSearch(query); 
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Album album = _searchResults[index];
                return ListTile(
                  leading: album.imageUrl != null
                      ? Image.network(
                          album.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(width: 50, height: 50), 
                  title: Text(album.name ?? ''),
                  subtitle: Text(album.artiste?.map((e) => e.name).join(', ') ?? ''),
                  onTap: () {
                    context.go('/a/albumdetails/${album.id}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
