import 'package:flutter/material.dart';
import 'package:jokes_app/models/jokes_models.dart';
import 'package:jokes_app/screens/details.dart';
import 'package:jokes_app/screens/random_joke.dart';
import 'package:jokes_app/screens/favorites.dart';
import 'package:jokes_app/services/api_service.dart';
import 'package:jokes_app/widgets/joke_type_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> jokeTypes = [];
  List<Joke> favoriteJokes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
  }

  void fetchJokeTypes() async {
    try {
      var types = await ApiService.getJokeTypes();
      setState(() {
        jokeTypes = types;
      });
    } catch (e) {
      print(e);
    }
  }

  void toggleFavorite(Joke joke) {
    setState(() {
      if (!favoriteJokes.any((j) => j.id == joke.id)) {
        favoriteJokes.add(joke);
      } else {
        favoriteJokes.removeWhere((j) => j.id == joke.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            favoriteJokes.contains(joke) ? 'Added to favorites!' : 'Removed from favorites!')),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.pink[200],
            title: const Text("Joke Types"),
            actions: [
        IconButton(
        icon: const Icon(Icons.favorite),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesScreen(favoriteJokes: favoriteJokes),
          ),
        );
      },
    ),
    TextButton(

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RandomJoke(),
          ),
        );
      },
      child: const Text(
        "Random Joke",
        style: TextStyle(color: Colors.black),
      ),
    ),
            ],
        ),
      body: Column(
        children: [
          // Title above the grid
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Choose the type of jokes you would like to read',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: jokeTypes.length,
              itemBuilder: (context, index) {
                return JokeTypeCard(
                  jokeType: jokeTypes[index],
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => Details(
                    type: jokeTypes[index],
                    favoriteJokes: favoriteJokes,
                    toggleFavorite: toggleFavorite,
                    ),
                    ),
                    );
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
