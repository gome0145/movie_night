import 'package:flutter/material.dart';
import 'package:movie_night/components/button.dart';
import '../utils/http_helper.dart';
import 'package:confetti/confetti.dart';
import '../components/SharedPreferencesManager.dart';
import '../model/movie.dart';
import '../model/vote.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late Future<List<Movie>> movies;
  late Future<VoteResult> voteResult;
  bool? voteSaved = false;
  int currentIndex = 0;
  late ConfettiController _centerController;
  int moviesPage = 1;
  late List<String>? movieInfo;
  int movieIdMatch = 0;

  void fetchMovies() {
    try {
      movies = HttpHelper.fetchMovies('get', moviesPage);
    } catch (ex) {
      print(ex.toString());
    }
  }

  void fetchVote(int movieId, bool vote) async {
    try {
      var result = await HttpHelper.fetchVote('get', movieId, vote);

      setState(() {
        voteSaved = result.match;
        movieIdMatch = int.parse(result
            .movieId); // Actualiza el movieId con el valor devuelto por fetchVote
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> fetchAdditionalMovies() async {
    try {
      final additionalMovies =
          await HttpHelper.fetchMovies('get', moviesPage + 1);
      final currentMovies = await movies;
      setState(() {
        movies = Future.value([...currentMovies, ...additionalMovies]);
        moviesPage++;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select a Movie",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Movie>>(
          future: movies,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (voteSaved!) {
              _centerController.play();
              var matchedMovie = snapshot.data!
                  .firstWhere((movie) => movie.id == movieIdMatch);
              var moviePath = matchedMovie.posterPath;
              return SafeArea(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: _centerController,
                        blastDirection: 3.14 / 2,
                        maxBlastForce: 5,
                        minBlastForce: 1,
                        emissionFrequency: 0.03,
                        numberOfParticles: 10,
                        gravity: 0,
                      ),
                    ),
                    AlertDialog(
                      title: Text(
                        "Match!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.indigo.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SizedBox(
                        height: 425,
                        child: Column(
                          children: [
                            Image(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w1280$moviePath'),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.indigo,
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Popularity",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.indigo.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      matchedMovie.popularity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/welcome',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              final currentMovie = snapshot.data![currentIndex];
              var moviePath = currentMovie.posterPath;
              if (currentIndex == snapshot.data!.length - 1) {
                fetchAdditionalMovies();
              }
              return Dismissible(
                key: Key(currentMovie.id.toString()),
                onDismissed: (direction) async {
                  bool vote = direction == DismissDirection.startToEnd;
                  SharedPreferencesManager.setMovieInfo([
                    currentMovie.title,
                    currentMovie.posterPath,
                    currentMovie.popularity.toString(),
                  ]);
                  fetchVote(currentMovie.id, vote);
                  setState(() {
                    currentIndex++;
                  });
                },
                background: Container(
                  color: Colors.green,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('images/like.png'),
                      fit: BoxFit.contain,
                      width: 150,
                    ),
                  ),
                ),
                secondaryBackground: const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('images/dislike.png'),
                    fit: BoxFit.contain,
                    width: 150,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.indigo,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 3.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  height: 670,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          currentMovie.title,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image(
                          image: NetworkImage(
                            'https://image.tmdb.org/t/p/w1280$moviePath',
                          ),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.indigo,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(currentMovie.voteAverage.toString()),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(currentMovie.popularity.toString()),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Reviews"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: AlertDialog(
                  title: const Text("Error"),
                  content: Text(snapshot.error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/welcome');
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.indigo,
                ),
              );
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
