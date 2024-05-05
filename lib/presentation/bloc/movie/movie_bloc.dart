import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_movies/core/constants/path_constants.dart';
import 'package:we_movies/data/models/now_playing_res.dart';
import 'package:we_movies/data/models/results.dart';
import 'package:we_movies/data/models/top_rated_res.dart';
import 'package:we_movies/domain/usecase/movie_usecase.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({required MovieUseCase movieUseCase})
      : _movieUseCase = movieUseCase,
        super(const MovieState()) {
    on<FetchNowPlayingMoviesEvent>(_mapFetchNowPlayingMoviesEventToState);
    on<FetchTopRatedMoviesEvent>(_mapFetchTopRatedMoviesEventToState);
    on<FetchCachedDataEvent>(_mapFetchCachedDataEventToState);
    on<FetchNowAndTopRatedMoviesEvent>(
        _mapFetchNowAndTopRatedMoviesEventToState);
  }

  Future<void> _mapFetchNowPlayingMoviesEventToState(
    FetchNowPlayingMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(nowPlayingStatus: NowPlayingStatus.paginationLoading));
    final res = await _movieUseCase.getNowPlayingMovies(
      pageNumber: event.pageNumber,
    );
    res.fold(
      (error) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.error,
        message: error.message,
      )),
      (data) async {
        if (data.page == 1) {
          nowPlayingBox.clear();
          nowPlayingBox.put(PathConstants.nowPlayingDbPath, data.toJson());
        }
        if (event.pageNumber > 1) {
          List<Results> oldData = state.nowPlayingRes?.results ?? [];
          data.results = oldData + (data.results ?? []);
        }
        emit(state.copyWith(
          nowPlayingRes: data,
          nowPlayingStatus: NowPlayingStatus.paginationLoaded,
        ));
      },
    );
  }

  Future<void> _mapFetchTopRatedMoviesEventToState(
    FetchTopRatedMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(topRatedStatus: TopRatedStatus.paginationLoading));
    final res = await _movieUseCase.getTopRatedMovies(
      pageNumber: event.pageNumber,
    );
    res.fold(
        (error) => emit(
              state.copyWith(
                topRatedStatus: TopRatedStatus.error,
                message: error.message,
              ),
            ), (data) async {
      if (data.page == 1) {
        topRatedBox.clear();
        topRatedBox.put(PathConstants.topRatedDbPath, data.toJson());
      }
      if (event.pageNumber > 1) {
        List<Results> oldData = state.topRatedRes?.results ?? [];
        data.results = oldData + (data.results ?? []);
      }
      emit(
        state.copyWith(
          topRatedRes: data,
          topRatedStatus: TopRatedStatus.paginationLoaded,
        ),
      );
    });
  }

  Future<void> _mapFetchCachedDataEventToState(
    FetchCachedDataEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(
      cachingStatus: CachingStatus.loading,
    ));
    final nowPlayingData = nowPlayingBox.get(PathConstants.nowPlayingDbPath);
    final topRatedData = topRatedBox.get(PathConstants.topRatedDbPath);
    if (nowPlayingData != null && topRatedData != null) {
      emit(state.copyWith(
        nowPlayingRes: NowPlayingRes.fromJson(nowPlayingData),
        nowPlayingStatus: NowPlayingStatus.loaded,
        topRatedRes: TopRatedRes.fromJson(topRatedData),
        topRatedStatus: TopRatedStatus.loaded,
        cachingStatus: CachingStatus.cached,
      ));
    } else {
      emit(state.copyWith(cachingStatus: CachingStatus.notCached));
    }
  }

  Future<void> _mapFetchNowAndTopRatedMoviesEventToState(
    FetchNowAndTopRatedMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    final response = await Future.wait([
      _movieUseCase.getNowPlayingMovies(pageNumber: event.pageNumber),
      _movieUseCase.getTopRatedMovies(pageNumber: event.pageNumber),
    ]);

    final nowPlayingRes = response[0];
    nowPlayingRes.fold(
      (error) => emit(state.copyWith(
        nowPlayingStatus: NowPlayingStatus.error,
        message: error.message,
      )),
      (data) async {
        print('data nowPlaying: $data');
        if ((data as NowPlayingRes).page == 1) {
          nowPlayingBox.clear();
          nowPlayingBox.put(PathConstants.nowPlayingDbPath, data.toJson());
        }
        emit(state.copyWith(
          nowPlayingRes: data,
          nowPlayingStatus: NowPlayingStatus.loaded,
        ));
      },
    );

    final topRatedRes = response[1];
    topRatedRes.fold(
      (error) => emit(state.copyWith(
        topRatedStatus: TopRatedStatus.error,
        message: error.message,
      )),
      (data) async {
        print('data topRated: $data');
        if ((data as TopRatedRes).page == 1) {
          topRatedBox.clear();
          topRatedBox.put(PathConstants.topRatedDbPath, data.toJson());
        }
        emit(state.copyWith(
          topRatedRes: data,
          topRatedStatus: TopRatedStatus.loaded,
          cachingStatus: CachingStatus.cached,
        ));
      },
    );
  }

  final MovieUseCase _movieUseCase;
  final nowPlayingBox = Hive.box(PathConstants.nowPlayingDbPath);
  final topRatedBox = Hive.box(PathConstants.topRatedDbPath);
}
