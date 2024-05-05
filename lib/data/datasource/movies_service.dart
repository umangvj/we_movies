import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/top_rated_res.dart';
import 'package:we_movies/services/network/movies_client.dart';

class MoviesDataSource {
  MoviesDataSource({required MoviesClient moviesClient})
      : _moviesClient = moviesClient;
  final MoviesClient _moviesClient;

  Future<NowPlayingRes> getNowPlayingMovies({required int pageNumber}) async {
    try {
      final response = await _moviesClient.getNowPlayingMovies(pageNumber);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<TopRatedRes> getTopRatedMovies({required int pageNumber}) async {
    try {
      final response = await _moviesClient.getTopRatedMovies(pageNumber);
      return response;
    } catch (_) {
      rethrow;
    }
  }
}
