import 'package:dartz/dartz.dart';
import 'package:we_movies/data/models/api_error.dart';
import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/top_rated_res.dart';
import 'package:we_movies/domain/repositories/movie_repository.dart';

class MovieUseCase {
  MovieUseCase({required this.movieRepository});

  final MovieRepository movieRepository;

  Future<Either<ApiError, NowPlayingRes>> getNowPlayingMovies({
    required int pageNumber,
  }) async {
    print('api called getNowPlayingMovies');
    return movieRepository.getNowPlayingMovies(pageNumber: pageNumber);
  }

  Future<Either<ApiError, TopRatedRes>> getTopRatedMovies({
    required int pageNumber,
  }) async {
    print('api called getTopRatedMovies');
    return movieRepository.getTopRatedMovies(pageNumber: pageNumber);
  }
}
