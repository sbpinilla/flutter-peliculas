import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/pages/pelicula_detalle_page.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final PeliculasProvider peliculasProvider = PeliculasProvider();
  String seleccion = '';

  final peliculas = [
    'Sergio',
    'Sebastian',
    'Baudilio',
    'Bajonero',
    'Pinilla',
    'Martinez',
    'Francy',
    'Patricia',
    'Fernadez',
    'Juyo',
  ];
  final peliculasRecientes = [
    'Sergio',
    'Pinilla',
  ];

  @override
  String get searchFieldLabel => 'Buscar...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // ACCIONES DE NUESTRA APPBAR

    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          progress: transitionAnimation, icon: AnimatedIcons.menu_arrow),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // CREA LOS RESULTADOS A MOSTRAR

    return Text(seleccion);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // SUGERENCIA QUE APARECEN CUANDO EL USUARIO ESCRIBE

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.map((p) {
              p.uniqueId = '${p.id}-search';

              return ListTile(
                onTap: () {
                  close(context, null);
                  Navigator.pushNamed(context, PeliculaDetallePage.ruta,
                      arguments: p);
                },
                leading: Hero(
                  tag: p.uniqueId,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: FadeInImage(
                          width: 50.0,
                          fit: BoxFit.contain,
                          placeholder: AssetImage('assets/img/no-image.jpg'),
                          image: NetworkImage(p.getPosterImg()))),
                ),
                title: Text(p.title),
                subtitle: Text(p.originalTitle),
              );
            }).toList(),
          );
        } else {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );

/*
    final listBusqueda = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listBusqueda.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listBusqueda[index]),
          onTap: () {
            seleccion = listBusqueda[index];
            //showResults(context);
          },
        );
      },
    );
    */
  }
}
