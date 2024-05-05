import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_movies/data/models/results.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchEvent>((event, emit) {
      if (event is SearchQueryChanged) {
        Set<Results> nowPlayingSearchResult = {};
        Set<Results> topRatedSearchResult = {};
        if (event.query.isNotEmpty) {
          nowPlayingSearchResult = state.nowPlayingSearchList
              .where((element) => (element.title ?? '')
                  .toLowerCase()
                  .contains(event.query.toLowerCase()))
              .toSet();
          topRatedSearchResult = state.topRatedSearchList
              .where((element) => (element.title ?? '')
                  .toLowerCase()
                  .contains(event.query.toLowerCase()))
              .toSet();

          emit(state.copyWith(
            query: event.query,
            isSearchActive: true,
            nowPlayingResult: nowPlayingSearchResult.isNotEmpty
                ? nowPlayingSearchResult.toList()
                : [],
            topRatedResult: topRatedSearchResult.isNotEmpty
                ? topRatedSearchResult.toList()
                : [],
          ));
        } else {
          emit(state.copyWith(
            isSearchActive: false,
          ));
        }
      } else if (event is GetSearchList) {
        emit(state.copyWith(
            nowPlayingSearchList: event.nowPlayingSearchList,
            topRatedSearchList: event.topRatedSearchList));
      } else if (event is UpdateSearchActive) {
        emit(state.copyWith(isSearchActive: event.isSearchActive));
      }
    });
  }
}
