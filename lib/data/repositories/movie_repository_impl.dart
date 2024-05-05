import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:we_movies/data/datasource/movies_service.dart';
import 'package:we_movies/data/models/api_error.dart';
import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/top_rated_res.dart';
import 'package:we_movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  MovieRepositoryImpl({required MoviesDataSource moviesDataSource})
      : _moviesDataSource = moviesDataSource;
  final MoviesDataSource _moviesDataSource;

  @override
  Future<Either<ApiError, NowPlayingRes>> getNowPlayingMovies(
      {required int pageNumber}) async {
    try {
      final response =
          await _moviesDataSource.getNowPlayingMovies(pageNumber: pageNumber);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError(message: e.message));
    }
  }

  @override
  Future<Either<ApiError, TopRatedRes>> getTopRatedMovies(
      {required int pageNumber}) async {
    try {
      final response =
          await _moviesDataSource.getTopRatedMovies(pageNumber: pageNumber);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError(message: e.message));
    }
  }
}
