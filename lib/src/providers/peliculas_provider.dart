import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apiKey = 'a7eb8b7434b52f3e86367c4edec8f598';
  String _lenguage = 'es-ES';
  String _api = 'api.themoviedb.org';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_api, "3/movie/now_playing",
        {'api_key': _apiKey, 'language': _lenguage});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) {
      return [];
    }
    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_api, "3/movie/popular", {
      'api_key': _apiKey,
      'language': _lenguage,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decoudedData = json.decode(resp.body);
    final Peliculas peliculas = Peliculas.fromJsonList(decoudedData['results']);
    return peliculas.listaPeliculas;
  }

  Future<List<Actor>> getActores(String idPelicula) async {
    final url = Uri.https(_api, "3/movie/$idPelicula/credits",
        {'api_key': _apiKey, 'language': _lenguage});

    final resp = await http.get(url);
    final decoudedData = json.decode(resp.body);
    final Actores actores = Actores.fromJsonList(decoudedData['cast']);
    return actores.listaActores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_api, "3/search/movie",
        {'api_key': _apiKey, 'language': _lenguage, 'query': query});

    return await _procesarRespuesta(url);
  }
}
