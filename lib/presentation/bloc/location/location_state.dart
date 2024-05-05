part of 'location_bloc.dart';

enum LocationStatus {
  initial,
  loading,
  enabled,
  disabled,
  denied,
  deniedForever
}

class LocationState extends Equatable {
  const LocationState({
    this.placemark,
    this.mainAddress = '',
    this.secondaryAddress = '',
    this.status = LocationStatus.initial,
    this.showLocationAlertDialog = false,
  });

  final Placemark? placemark;
  final String mainAddress;
  final String secondaryAddress;
  final LocationStatus status;
  final bool showLocationAlertDialog;

  @override
  List<Object?> get props => [
        placemark,
        mainAddress,
        secondaryAddress,
        status,
        showLocationAlertDialog,
      ];

  LocationState copyWith({
    Placemark? placemark,
    String? mainAddress,
    String? secondaryAddress,
    LocationStatus? status,
    bool? showLocationAlertDialog,
  }) {
    return LocationState(
      placemark: placemark ?? this.placemark,
      mainAddress: mainAddress ?? this.mainAddress,
      secondaryAddress: secondaryAddress ?? this.secondaryAddress,
      status: status ?? this.status,
      showLocationAlertDialog:
          showLocationAlertDialog ?? this.showLocationAlertDialog,
    );
  }
}
