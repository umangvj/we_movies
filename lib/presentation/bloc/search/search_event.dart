part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class UpdateSearchActive extends SearchEvent {
  const UpdateSearchActive({required this.isSearchActive});

  final bool isSearchActive;
  @override
  List<Object> get props => [isSearchActive];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}

class GetSearchList extends SearchEvent {
  const GetSearchList(
      {required this.nowPlayingSearchList, required this.topRatedSearchList});

  final List<Results> nowPlayingSearchList;
  final List<Results> topRatedSearchList;

  @override
  List<Object> get props => [];
}

// class SearchResult extends SearchEvent {
//
//   const SearchResult();
//
//   @override
//   List<Object> get props => [];
// }
