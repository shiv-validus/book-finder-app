part of 'sensor_cubit.dart';

abstract class SensorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SensorInitial extends SensorState {}

class SensorLoading extends SensorState {}

class SensorFlashlightToggled extends SensorState {
  final bool isOn;

  SensorFlashlightToggled(this.isOn);

  @override
  List<Object?> get props => [isOn];
}

class SensorError extends SensorState {
  final String message;

  SensorError(this.message);

  @override
  List<Object?> get props => [message];
}
