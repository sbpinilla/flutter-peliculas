import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/pages/pelicula_detalle_page.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  CardSwiper({@required this.peliculas});
  final _swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    final tarjeta = Container(
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}Tarjeta';
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PeliculaDetallePage.ruta,
                  arguments: peliculas[index]);
            },
            child: Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                    image: NetworkImage(peliculas[index].getPosterImg())),
              ),
            ),
          );
        },
        layout: SwiperLayout.STACK,
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.5,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );

    return tarjeta;
  }
}
