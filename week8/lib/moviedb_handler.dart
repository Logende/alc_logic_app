import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:week8/model/movie.dart';


Future<Movie> fetchMovie(String path) async {
  var uri = 'https://api.themoviedb.org/$path?api_key=16eec700cad97e651a24ed6b6e2ec5e3';

  final response = await http
      .get(Uri.parse(uri));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Movie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Movie');
  }
}