part of 'movie_bloc.dart';

enum NowPlayingStatus {
  initial,
  loading,
  loaded,
  error,
  paginationLoading,
  paginationLoaded
}

enum TopRatedStatus {
  initial,
  loading,
  loaded,
  error,
  paginationLoading,
  paginationLoaded
}

enum CachingStatus { initial, loading, cached, notCached }

class MovieState extends Equatable {
  const MovieState({
    this.nowPlayingRes,
    this.topRatedRes,
    this.nowPlayingStatus = NowPlayingStatus.initial,
    this.topRatedStatus = TopRatedStatus.initial,
    this.cachingStatus = CachingStatus.initial,
    this.message,
  });

  final NowPlayingRes? nowPlayingRes;
  final TopRatedRes? topRatedRes;
  final NowPlayingStatus nowPlayingStatus;
  final TopRatedStatus topRatedStatus;
  final CachingStatus cachingStatus;
  final String? message;

  @override
  List<Object?> get props => [
        nowPlayingRes,
        topRatedRes,
        nowPlayingStatus,
        topRatedStatus,
        cachingStatus,
        message,
      ];

  MovieState copyWith({
    NowPlayingRes? nowPlayingRes,
    TopRatedRes? topRatedRes,
    NowPlayingStatus? nowPlayingStatus,
    TopRatedStatus? topRatedStatus,
    CachingStatus? cachingStatus,
    String? message,
  }) {
    return MovieState(
      nowPlayingRes: nowPlayingRes ?? this.nowPlayingRes,
      topRatedRes: topRatedRes ?? this.topRatedRes,
      nowPlayingStatus: nowPlayingStatus ?? this.nowPlayingStatus,
      topRatedStatus: topRatedStatus ?? this.topRatedStatus,
      cachingStatus: cachingStatus ?? this.cachingStatus,
      message: message ?? this.message,
    );
  }
}
