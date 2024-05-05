part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class FetchNowPlayingMoviesEvent extends MovieEvent {
  const FetchNowPlayingMoviesEvent({required this.pageNumber});

  final int pageNumber;

  @override
  List<Object> get props => [pageNumber];
}

class FetchTopRatedMoviesEvent extends MovieEvent {
  const FetchTopRatedMoviesEvent({required this.pageNumber});

  final int pageNumber;

  @override
  List<Object> get props => [pageNumber];
}

class FetchCachedDataEvent extends MovieEvent {
  const FetchCachedDataEvent();

  @override
  List<Object> get props => [];
}

class FetchNowAndTopRatedMoviesEvent extends MovieEvent {
  const FetchNowAndTopRatedMoviesEvent({required this.pageNumber});

  final int pageNumber;

  @override
  List<Object> get props => [pageNumber];
}
