import 'package:dartz/dartz.dart';
import 'package:we_movies/data/models/api_error.dart';
import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/top_rated_res.dart';

abstract class MovieRepository {
  Future<Either<ApiError, NowPlayingRes>> getNowPlayingMovies(
      {required int pageNumber});

  Future<Either<ApiError, TopRatedRes>> getTopRatedMovies(
      {required int pageNumber});
}
