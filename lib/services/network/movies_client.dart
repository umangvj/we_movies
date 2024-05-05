import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/top_rated_res.dart';

part 'movies_client.g.dart';

@RestApi()
abstract class MoviesClient {
  factory MoviesClient(Dio dio, {String baseUrl}) = _MoviesClient;

  @GET('now_playing?language=en-US&page={pageNumber}')
  Future<NowPlayingRes> getNowPlayingMovies(
    @Path() int pageNumber,
  );

  @GET('top_rated?language=en-US&page={pageNumber}')
  Future<TopRatedRes> getTopRatedMovies(
    @Path() int pageNumber,
  );
}
