import 'package:flutter/material.dart';
import 'package:projects/screens/details.dart';
import 'package:projects/screens/random_joke.dart';
import 'package:projects/services/api_service.dart';
import 'package:projects/widgets/joke_type_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> jokeTypes = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.lightBlue[200],
        title: Text("Joke Type"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RandomJoke(),
                    ));
              },
              child: const Text(
                "Random Joke",
                style: TextStyle(color: Colors.black),
              )),
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
              padding: EdgeInsets.all(10),
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
                          builder: (context) =>
                              Details(type: jokeTypes[index]),
                        ));
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