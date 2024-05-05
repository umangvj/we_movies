import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const LocationState()) {
    on<LocationEvent>((event, emit) async {
      if (event is FetchUserLocation) {
        if (state.status != LocationStatus.loading) {
          if (state.status != LocationStatus.enabled) {
            emit(state.copyWith(status: LocationStatus.loading));
            bool serviceEnabled;
            LocationPermission permission;
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              emit(state.copyWith(status: LocationStatus.disabled));
            } else {
              permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied ||
                  permission == LocationPermission.deniedForever) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.whileInUse ||
                    permission == LocationPermission.always) {
                  Position? currentPosition;
                  await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high)
                      .then((Position position) async {
                    currentPosition = position;
                    await placemarkFromCoordinates(currentPosition!.latitude,
                            currentPosition!.longitude)
                        .then((List<Placemark> placemarks) {
                      Placemark place = placemarks[0];
                      emit(
                        state.copyWith(
                          placemark: place,
                          mainAddress: place.name,
                          secondaryAddress:
                              '${place.subLocality}, ${place.locality}',
                          status: LocationStatus.enabled,
                          showLocationAlertDialog: false,
                        ),
                      );
                    }).catchError((e) {
                      debugPrint(e);
                    });
                  }).catchError((e) {
                    debugPrint(e);
                  });
                } else if (permission == LocationPermission.denied ||
                    permission == LocationPermission.deniedForever) {
                  emit(state.copyWith(status: LocationStatus.denied));
                }
              } else {
                Position? currentPosition;
                await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high)
                    .then((Position position) async {
                  currentPosition = position;
                  await placemarkFromCoordinates(
                          currentPosition!.latitude, currentPosition!.longitude)
                      .then((List<Placemark> placemarks) {
                    Placemark place = placemarks[0];
                    emit(
                      state.copyWith(
                        placemark: place,
                        mainAddress: place.name,
                        secondaryAddress:
                            '${place.subLocality}, ${place.locality}',
                        status: LocationStatus.enabled,
                        showLocationAlertDialog: false,
                      ),
                    );
                  }).catchError((e) {
                    debugPrint(e);
                  });
                }).catchError((e) {
                  debugPrint(e);
                });
              }
            }
          }
        }
      } else if (event is RequestLocationPermission) {
        emit(state.copyWith(status: LocationStatus.loading));
        await Geolocator.openAppSettings();
      } else if (event is UpdateToInitialStatus) {
        if (state.status != LocationStatus.initial) {
          emit(const LocationState());
        }
      } else if (event is ShowLocationAlertDialog) {
        emit(state.copyWith(showLocationAlertDialog: true));
      }
    });
  }
}
