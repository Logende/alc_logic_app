import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week8/moviedb_handler.dart';
import 'package:week8/widgets/die.dart';
import 'package:week8/widgets/info.dart';
import 'package:week8/widgets/navigation_bar.dart';
import 'package:week8/widgets/timer.dart';

import '../model/dice.dart';
import '../model/movie.dart';
import '../providers.dart';

class ScreenMovies extends ConsumerStatefulWidget {
   const ScreenMovies({super.key});


   static String get routeName => 'movies';
   static String get routeLocation => '/movies';

  final String title = "Movies";


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScreenMoviesState();
  }
}




   class _ScreenMoviesState extends ConsumerState<ScreenMovies> {

     late Future<Movie> futureMovie;

     @override
     void initState() {
       super.initState();
     }

  @override
  Widget build(BuildContext context) {
    Dice dice = ref.watch(modelProvider).currentDice();
    int sum = dice.die.reduce((value, element) => value + element);
    futureMovie = fetchMovie("3/movie/${500 + sum}");

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            FutureBuilder<Movie>(
              future: futureMovie,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Title: ${snapshot.data!.title}"),
                        Text("Release Date: ${snapshot.data!.release_date}"),
                        Text("Status: ${snapshot.data!.status}"),
                      ]);

                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),

            NavigationBarWidget(ref: ref),


          ],
        ),
      ),
    );
  }
   }

