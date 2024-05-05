part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.isSearchActive = false,
    this.nowPlayingSearchList = const <Results>[],
    this.nowPlayingResult = const <Results>[],
    this.topRatedSearchList = const <Results>[],
    this.topRatedResult = const <Results>[],
    this.searchStatus = SearchStatus.initial,
  });

  final String query;
  final bool isSearchActive;
  final List<Results> nowPlayingSearchList;
  final List<Results> topRatedSearchList;
  final List<Results> nowPlayingResult;
  final List<Results> topRatedResult;
  final SearchStatus searchStatus;

  @override
  List<Object> get props => [
        query,
        isSearchActive,
        nowPlayingSearchList,
        nowPlayingResult,
        topRatedSearchList,
        topRatedResult,
        searchStatus
      ];

  SearchState copyWith({
    String? query,
    bool? isSearchActive,
    List<Results>? nowPlayingSearchList,
    List<Results>? nowPlayingResult,
    List<Results>? topRatedSearchList,
    List<Results>? topRatedResult,
    SearchStatus? searchStatus,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      nowPlayingSearchList: nowPlayingSearchList ?? this.nowPlayingSearchList,
      nowPlayingResult: nowPlayingResult ?? this.nowPlayingResult,
      topRatedSearchList: topRatedSearchList ?? this.topRatedSearchList,
      topRatedResult: topRatedResult ?? this.topRatedResult,
      searchStatus: searchStatus ?? this.searchStatus,
    );
  }
}
