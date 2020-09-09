import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetallePage extends StatelessWidget {
  static final ruta = "detalle";
  final PeliculasProvider peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(slivers: [
        _crearAppBar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10.0,
          ),
          _posterTitulo(pelicula, context),
          _descripcion(pelicula),
          _descripcion(pelicula),
          _descripcion(pelicula),
          _crearActores(pelicula)
        ]))
      ]),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          image: NetworkImage(pelicula.getBackdropImg()),
        ),
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          //overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                height: 150.0,
                image: NetworkImage(pelicula.getPosterImg()),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                pelicula.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pelicula.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.star_border),
                  Text(
                    pelicula.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearActores(Pelicula pelicula) {
    return FutureBuilder(
      future: peliculasProvider.getActores(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) {
          final actores = snapshot.data;

          print(actores[0].name);
          return _crearActoresPageView(actores);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return Container(
      height: 160.0,
      child: PageView.builder(
        itemCount: actores.length,
        pageSnapping: false,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        //children: _tarjetas(context),
        itemBuilder: (context, index) {
          return _generarTarjetas(context, actores[index]);
        },
      ),
    );
  }

  Widget _generarTarjetas(BuildContext context, Actor actor) {
    final peliculaTarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 130.0,
                image: NetworkImage(actor.getFoto())),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
    return peliculaTarjeta;
  }
}
