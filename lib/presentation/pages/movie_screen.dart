import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:we_movies/core/constants/color_constants.dart';
import 'package:we_movies/core/constants/path_constants.dart';
import 'package:we_movies/core/injection_container.dart';
import 'package:we_movies/core/utils/language_locale.dart';
import 'package:we_movies/data/models/results.dart';
import 'package:we_movies/presentation/bloc/location/location_bloc.dart';
import 'package:we_movies/presentation/bloc/movie/movie_bloc.dart';
import 'package:we_movies/presentation/bloc/search/search_bloc.dart';
import 'package:we_movies/presentation/widgets/details_clipper.dart';
import 'package:we_movies/presentation/widgets/now_playing_clipper.dart';
import 'package:we_movies/presentation/widgets/we_movies_clipper.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({
    required this.locationBloc,
    super.key,
  });

  final LocationBloc locationBloc;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late MovieBloc _movieBloc;
  late LocationBloc _locationBloc;
  late SearchBloc _searchBloc;
  late ScrollController _scrollController;
  late ScrollController _nowPlayingScrollController;
  late TextEditingController _searchController;
  Set<Results> searchResults = {};

  DateFormat dateFormat = DateFormat('d MMM yyyy');

  @override
  void initState() {
    _locationBloc = widget.locationBloc;
    _movieBloc = getIt<MovieBloc>();
    _searchBloc = getIt<SearchBloc>();
    _movieBloc.add(const FetchCachedDataEvent());
    _searchController = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent - 50 &&
            !_scrollController.position.outOfRange &&
            ((_movieBloc.state.topRatedRes?.page ?? 0) + 1 <=
                (_movieBloc.state.topRatedRes?.totalPages ?? 0)) &&
            _movieBloc.state.topRatedStatus !=
                TopRatedStatus.paginationLoading &&
            !(_searchBloc.state.isSearchActive &&
                _searchBloc.state.query.isNotEmpty)) {
          _movieBloc.add(FetchTopRatedMoviesEvent(
            pageNumber: (_movieBloc.state.topRatedRes?.page ?? 1) + 1,
          ));
        }
      });
    _nowPlayingScrollController = ScrollController()
      ..addListener(() {
        if (_nowPlayingScrollController.offset >=
                _nowPlayingScrollController.position.maxScrollExtent - 50 &&
            !_nowPlayingScrollController.position.outOfRange &&
            ((_movieBloc.state.nowPlayingRes?.page ?? 0) + 1 <=
                (_movieBloc.state.nowPlayingRes?.totalPages ?? 0)) &&
            _movieBloc.state.nowPlayingStatus !=
                NowPlayingStatus.paginationLoading &&
            !(_searchBloc.state.isSearchActive &&
                _searchBloc.state.query.isNotEmpty)) {
          _movieBloc.add(FetchNowPlayingMoviesEvent(
            pageNumber: (_movieBloc.state.nowPlayingRes?.page ?? 1) + 1,
          ));
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _movieBloc.add(const FetchNowAndTopRatedMoviesEvent(pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: BlocConsumer<LocationBloc, LocationState>(
          bloc: _locationBloc,
          listener: (context, locationState) {
            // TODO: implement listener
          },
          builder: (context, locationState) {
            return BlocConsumer<MovieBloc, MovieState>(
              bloc: _movieBloc,
              listener: (context, movieState) {
                if (movieState.cachingStatus == CachingStatus.notCached) {
                  _movieBloc
                      .add(const FetchNowAndTopRatedMoviesEvent(pageNumber: 1));
                }
                if (movieState.nowPlayingStatus == NowPlayingStatus.loaded &&
                    movieState.topRatedStatus == TopRatedStatus.loaded) {
                  Set<Results> nowPlayingSearchList = {};
                  Set<Results> topRatedSearchList = {};
                  nowPlayingSearchList
                      .addAll(movieState.nowPlayingRes?.results ?? []);
                  topRatedSearchList
                      .addAll(movieState.topRatedRes?.results ?? []);
                  _searchBloc.add(GetSearchList(
                    nowPlayingSearchList: nowPlayingSearchList.toList(),
                    topRatedSearchList: topRatedSearchList.toList(),
                  ));
                }
                if (movieState.topRatedStatus ==
                        TopRatedStatus.paginationLoading ||
                    movieState.nowPlayingStatus ==
                        NowPlayingStatus.paginationLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Loading more movies...'),
                    ),
                  );
                }
                if (movieState.topRatedStatus ==
                        TopRatedStatus.paginationLoaded ||
                    movieState.nowPlayingStatus ==
                        NowPlayingStatus.paginationLoaded ||
                    movieState.topRatedStatus == TopRatedStatus.loaded ||
                    movieState.nowPlayingStatus == NowPlayingStatus.loaded) {
                  Set<Results> nowPlayingSearchList = {};
                  Set<Results> topRatedSearchList = {};
                  nowPlayingSearchList
                      .addAll(movieState.nowPlayingRes?.results ?? []);
                  topRatedSearchList
                      .addAll(movieState.topRatedRes?.results ?? []);
                  _searchBloc.add(GetSearchList(
                    nowPlayingSearchList: nowPlayingSearchList.toList(),
                    topRatedSearchList: topRatedSearchList.toList(),
                  ));
                }
              },
              builder: (context, movieState) {
                return BlocConsumer<SearchBloc, SearchState>(
                  bloc: _searchBloc,
                  listener: (context, searchState) {
                    // TODO: implement listener
                  },
                  builder: (context, searchState) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorConstants.primaryColor,
                            ColorConstants.primaryColor,
                            Color(0xffD7DCDC),
                          ],
                          stops: [0.1, 0.2, 0.7],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              if (Platform.isAndroid)
                                const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 70),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.black,
                                                applyTextScaling: true,
                                              ),
                                              Text(
                                                locationState.placemark?.name ??
                                                    '-',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: Text(
                                              locationState.secondaryAddress,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2, bottom: 10),
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'we',
                                      style: GoogleFonts.ebGaramond(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: SearchBar(
                                  controller: _searchController,
                                  padding: const MaterialStatePropertyAll<
                                          EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                                  elevation:
                                      const MaterialStatePropertyAll<double>(
                                          0.0),
                                  onTap: () {
                                    // controller.openView();
                                    _searchBloc.add(
                                      const UpdateSearchActive(
                                          isSearchActive: true),
                                    );
                                  },
                                  onChanged: (value) {
                                    _searchBloc.add(
                                      SearchQueryChanged(query: value),
                                    );
                                    //controller.openView();
                                  },
                                  leading: const Icon(Icons.search),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ClipPath(
                                        clipper: WeMoviesClipper(),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          height: 150,
                                          color: const Color(0xffA595A1)
                                              .withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      left: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dateFormat.format(DateTime.now()),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          const Text(
                                            'We Movies',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${(movieState.nowPlayingRes?.results?.length ?? 0)} Movies are loaded in now playing',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if ((searchState.isSearchActive &&
                                  searchState.query.isNotEmpty &&
                                  searchState.nowPlayingResult.isEmpty &&
                                  searchState.topRatedResult.isEmpty))
                                const SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: Text(
                                      'No results found.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!(searchState.isSearchActive &&
                                  searchState.query.isNotEmpty &&
                                  searchState.nowPlayingResult.isEmpty))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'NOW PLAYING',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                            ColorConstants.secondaryColor,
                                            ColorConstants.primaryColor,
                                          ])),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 10),
                              if (movieState.nowPlayingStatus ==
                                  NowPlayingStatus.error)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      movieState.message ??
                                          'Error loading movies. Please try again later.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: searchState.isSearchActive &&
                                          searchState.query.isNotEmpty &&
                                          searchState.nowPlayingResult.isEmpty
                                      ? 0
                                      : 310,
                                  child: ListView.builder(
                                      controller: _nowPlayingScrollController,
                                      itemCount: searchState.isSearchActive &&
                                              searchState.query.isNotEmpty
                                          ? searchState.nowPlayingResult.length
                                          : (movieState.nowPlayingRes?.results
                                                  ?.length ??
                                              0),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      addAutomaticKeepAlives: true,
                                      itemBuilder: (context, index) {
                                        List<Results>? nowPlayingResults =
                                            (searchState.isSearchActive &&
                                                    searchState
                                                        .query.isNotEmpty)
                                                ? searchState.nowPlayingResult
                                                : movieState
                                                    .nowPlayingRes?.results;
                                        if (nowPlayingResults == null ||
                                            nowPlayingResults.isEmpty) {
                                          return const SizedBox();
                                        }
                                        return Stack(
                                          children: [
                                            ClipPath(
                                              clipper: NowPlayingClipper(),
                                              child: CachedNetworkImage(
                                                height:
                                                    300 * 1.1680327868852458,
                                                width: 300,
                                                imageUrl:
                                                    '${PathConstants.imageBaseUrl}${nowPlayingResults[index].posterPath}',
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) {
                                                  return const Padding(
                                                    padding:
                                                        EdgeInsets.all(120),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: ColorConstants
                                                          .primaryColor,
                                                    ),
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            ClipPath(
                                              clipper: DetailsClipper(),
                                              child: Container(
                                                height:
                                                    300 * 1.1680327868852458,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black
                                                      .withOpacity(0.75),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 75,
                                              top: 6,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${(nowPlayingResults[index].voteAverage)?.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[900],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 18,
                                                    color: Colors.amber,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 25,
                                              top: 6,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[700]
                                                          ?.withOpacity(0.65),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        Text(
                                                          nowPlayingResults[index]
                                                                          .popularity !=
                                                                      null &&
                                                                  nowPlayingResults[
                                                                              index]
                                                                          .popularity! >
                                                                      1000
                                                              ? '${(nowPlayingResults[index].popularity! / 1000).toDouble().toStringAsFixed(1)}K'
                                                              : '${nowPlayingResults[index].popularity?.toInt()}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[700]
                                                          ?.withOpacity(0.65),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 162,
                                              right: 75,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.language,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    LanguageLocal()
                                                        .getDisplayLanguage(
                                                            nowPlayingResults[
                                                                        index]
                                                                    .originalLanguage ??
                                                                'en'),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 32,
                                              left: 22,
                                              child: SizedBox(
                                                width: 300,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                        nowPlayingResults[index]
                                                                .title ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    SizedBox(
                                                      width: 210,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            CupertinoIcons
                                                                .calendar_today,
                                                            size: 18,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 3),
                                                          Expanded(
                                                            child: Text(
                                                              nowPlayingResults[
                                                                          index]
                                                                      .overview ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      nowPlayingResults[index]
                                                                      .voteCount !=
                                                                  null &&
                                                              nowPlayingResults[
                                                                          index]
                                                                      .voteCount! >
                                                                  1000
                                                          ? '${(nowPlayingResults[index].voteCount! / 1000).toDouble().toStringAsFixed(1)}K Votes'
                                                          : '${nowPlayingResults[index].voteCount} Votes',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              const SizedBox(height: 10),
                              if (!(searchState.isSearchActive &&
                                  searchState.query.isNotEmpty &&
                                  searchState.topRatedResult.isEmpty))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'TOP RATED',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                            ColorConstants.secondaryColor,
                                            ColorConstants.primaryColor,
                                          ])),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 10),
                              if (movieState.topRatedStatus ==
                                  TopRatedStatus.error)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      movieState.message ??
                                          'Error loading movies. Please try again later.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              else if (searchState.isSearchActive &&
                                  searchState.query.isNotEmpty &&
                                  searchState.topRatedResult.isEmpty)
                                const SizedBox(
                                  height: 100,
                                )
                              else
                                ListView.builder(
                                    itemCount: searchState.isSearchActive &&
                                            searchState.query.isNotEmpty
                                        ? searchState.topRatedResult.length
                                        : movieState
                                                .topRatedRes?.results?.length ??
                                            0,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      List<Results>? results =
                                          searchState.isSearchActive &&
                                                  searchState.query.isNotEmpty
                                              ? searchState.topRatedResult
                                              : movieState.topRatedRes?.results;
                                      if (results == null || results.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 5,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 200,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    '${PathConstants.imageBaseUrl}${results[index].backdropPath}',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 10,
                                                    child: Container(
                                                      height: 53,
                                                      width: 53,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[700]
                                                            ?.withOpacity(0.65),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            Text(
                                                              results[index].popularity !=
                                                                          null &&
                                                                      results[index]
                                                                              .popularity! >
                                                                          1000
                                                                  ? '${(results[index].popularity! / 1000).toDouble().toStringAsFixed(1)}K'
                                                                  : '${results[index].popularity?.toInt()}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 30),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    results[index].title ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        CupertinoIcons
                                                            .calendar_today,
                                                        size: 18,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Expanded(
                                                        child: Text(
                                                          results[index]
                                                                  .overview ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        results[index].voteCount !=
                                                                    null &&
                                                                results[index]
                                                                        .voteCount! >
                                                                    1000
                                                            ? '${(results[index].voteCount! / 1000).toDouble().toStringAsFixed(1)}K Votes'
                                                            : '${results[index].voteCount} Votes',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 3,
                                                        ),
                                                        child: SizedBox(
                                                          height: 15,
                                                          child:
                                                              VerticalDivider(
                                                            width: 15,
                                                            thickness: 2,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${(results[index].voteAverage)?.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 1),
                                                      const Icon(
                                                        Icons
                                                            .star_border_purple500_sharp,
                                                        // CupertinoIcons.star,
                                                        size: 18,
                                                        color: Colors.amber,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    }),
                              const SizedBox(height: 50),
                              if (searchState.isSearchActive &&
                                  searchState.query.isNotEmpty &&
                                  (searchState.topRatedResult.isEmpty ||
                                      searchState.nowPlayingResult.isEmpty))
                                const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
