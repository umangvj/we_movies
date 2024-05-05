import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_movies/data/datasource/movies_service.dart';
import 'package:we_movies/data/repositories/movie_repository_impl.dart';
import 'package:we_movies/domain/repositories/movie_repository.dart';
import 'package:we_movies/domain/usecase/movie_usecase.dart';
import 'package:we_movies/presentation/bloc/location/location_bloc.dart';
import 'package:we_movies/presentation/bloc/movie/movie_bloc.dart';
import 'package:we_movies/presentation/bloc/search/search_bloc.dart';
import 'package:we_movies/services/network/movies_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //Bloc
  getIt.registerFactory<MovieBloc>(
    () => MovieBloc(
      movieUseCase: getIt(),
    ),
  );

  getIt.registerFactory<LocationBloc>(
    () => LocationBloc(),
  );

  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(),
  );

  // Use cases
  getIt.registerLazySingleton<MovieUseCase>(
    () => MovieUseCase(movieRepository: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      moviesDataSource: getIt(),
    ),
  );

  // Data Sources

  getIt.registerLazySingleton<MoviesDataSource>(
    () => MoviesDataSource(
      moviesClient:
          MoviesClient(getIt(), baseUrl: 'https://api.themoviedb.org/3/movie/'),
    ),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<Dio>(() => Dio());
}
