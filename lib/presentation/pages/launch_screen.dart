import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_movies/core/injection_container.dart';
import 'package:we_movies/presentation/bloc/location/location_bloc.dart';
import 'package:we_movies/presentation/pages/home_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late LocationBloc _locationBloc;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
    WidgetsBinding.instance.addObserver(this);
    _locationBloc = getIt<LocationBloc>();
    _locationBloc.add(const FetchUserLocation());
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _locationBloc.add(const FetchUserLocation());
    } else if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _locationBloc.add(const UpdateToInitialStatus());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      bloc: _locationBloc,
      listener: (context, locationState) {
        if (locationState.status == LocationStatus.enabled &&
            locationState.mainAddress.isNotEmpty &&
            locationState.secondaryAddress.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 800)).then((value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    locationBloc: _locationBloc,
                  ),
                ),
              );
            });
          });
        }
        if (locationState.status == LocationStatus.deniedForever ||
            locationState.status == LocationStatus.denied ||
            locationState.status == LocationStatus.disabled ||
            locationState.showLocationAlertDialog) {
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            if (Platform.isAndroid) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Permission'),
                      content: const Text(
                        'We need your location permission to proceed further.',
                      ),
                      backgroundColor: Colors.white,
                      actions: [
                        TextButton(
                          onPressed: () {
                            _locationBloc.add(const ShowLocationAlertDialog());
                            Navigator.pop(context);
                          },
                          child: Text(
                            'cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _locationBloc
                                .add(const RequestLocationPermission());
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Allow',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Permission'),
                      content: const Text(
                        'We need your location permission to proceed further',
                      ),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: false,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'cancel',
                            style: TextStyle(
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: false,
                          onPressed: () {
                            _locationBloc
                                .add(const RequestLocationPermission());
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Allow',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }
          });
        }
      },
      builder: (context, locationState) {
        return Scaffold(
          body: Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black54,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 195,
                    width: 195,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: CircularProgressIndicator(
                        value: _animationController.value,
                        strokeWidth: 5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'wework',
                    style: GoogleFonts.ebGaramond(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
