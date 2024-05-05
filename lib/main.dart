import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:we_movies/core/config/shared_prefs.dart';
import 'package:we_movies/core/constants/color_constants.dart';
import 'package:we_movies/core/constants/path_constants.dart';
import 'package:we_movies/core/injection_container.dart';
import 'package:we_movies/presentation/bloc/location/location_bloc.dart';
import 'package:we_movies/presentation/pages/launch_screen.dart';
import 'package:we_movies/services/interceptors/auth_interceptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await SharedPrefs.setAccessToken(
    accessToken:
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YTg3ZTY4MDMyODIwMTIzZmQ0Yzg0YjQzNDhjYjc3ZCIsInN1YiI6IjY2Mjg5NDExOTFmMGVhMDE0YjAwOWU1ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6zIM73Giwg5M4wP6MX8KDCpee7IMnpnLTZUyMpETb08',
  );
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox(PathConstants.nowPlayingDbPath);
  await Hive.openBox(PathConstants.topRatedDbPath);
  await init();
  getIt<Dio>().interceptors.add(AuthInterceptor());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: MaterialApp(
        title: 'We Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorConstants.primaryColor),
          useMaterial3: true,
        ),
        home: const LaunchScreen(),
      ),
    );
  }
}
