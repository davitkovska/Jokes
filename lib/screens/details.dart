import 'package:flutter/material.dart';
import 'package:jokes_app/models/jokes_models.dart';
import 'package:jokes_app/services/api_service.dart';
import 'package:jokes_app/widgets/joke_card.dart';


  class Details extends StatefulWidget {
  final String type;
  final List<Joke> favoriteJokes;
  final Function(Joke) toggleFavorite;


  const Details({
  Key? key,
  required this.type,
  required this.favoriteJokes,
  required this.toggleFavorite,
  }) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
  }
  class _DetailsState extends State<Details> {
  late Future<List<Joke>> jokesFuture;
  late List<Joke> jokes;
  @override
  void initState() {
  super.initState();
  jokesFuture = fetchJokes();
  }
  Future<List<Joke>> fetchJokes() async {
  var jokesData = await ApiService.getJokesByType(widget.type);
  return jokesData.map((data) => Joke.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(

  appBar: AppBar(
  title: Text("Jokes: ${widget.type}"),
  backgroundColor: Colors.pink[200],
  elevation: 5,
  ),
  body: FutureBuilder<List<Joke>>(
  future: jokesFuture,
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
  return Center(child: Text("Error: ${snapshot.error}"));
  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return const Center(child: Text("No jokes available."));
  } else {
  jokes = snapshot.data!;
  return ListView.builder(
  itemCount: jokes.length,
  itemBuilder: (context, index) {
  var joke = jokes[index];
  bool isFavorite = widget.favoriteJokes.any((favorite) => favorite.id == joke.id);
  return JokeCard(
  key: ValueKey(joke.id),
  setup: joke.setup,
  punchline: joke.punchline,
  isFavorite: isFavorite,
  onFavoriteToggle: () {
  setState(() {
  widget.toggleFavorite(joke);
  });
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