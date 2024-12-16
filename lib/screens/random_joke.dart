import 'package:flutter/material.dart';
import 'package:projects/models/jokes model.dart';
import 'package:projects/services/api_service.dart';
import 'package:projects/widgets/joke_card.dart';

class RandomJoke extends StatefulWidget {
  const RandomJoke({Key? key}) : super(key: key);

  @override
  _RandomJokeState createState() => _RandomJokeState();
}

class _RandomJokeState extends State<RandomJoke> {
  Joke? joke;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getRandomJoke();
  }

  void getRandomJoke() async {
    try {
      final response = await ApiService.getRandomJoke();
      setState(() {
        joke = Joke.fromJson(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Random Joke"),
        backgroundColor: Colors.lightBlue[200],
        elevation: 5,),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Error: $error"))
          : joke == null
          ? const Center(child: Text("No joke available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: JokeCard(
            setup: joke!.setup,
            punchline: joke!.punchline,
          ),
        ),
      ),
    );
  }
}