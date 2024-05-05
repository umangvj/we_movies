part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class FetchUserLocation extends LocationEvent {
  const FetchUserLocation();

  @override
  List<Object> get props => [];
}

class RequestLocationPermission extends LocationEvent {
  const RequestLocationPermission();

  @override
  List<Object> get props => [];
}

class UpdateToInitialStatus extends LocationEvent {
  const UpdateToInitialStatus();

  @override
  List<Object> get props => [];
}

class ShowLocationAlertDialog extends LocationEvent {
  const ShowLocationAlertDialog();

  @override
  List<Object> get props => [];
}
