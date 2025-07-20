import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  bool isOn = false;

  // Native method channel
  static const MethodChannel _channel = MethodChannel('sensor_channel');

  SensorCubit() : super(SensorInitial());

  Future<void> toggleFlashlight() async {
    try {
      emit(SensorLoading());

      // Call native platform to toggle flashlight
      await _channel.invokeMethod('toggleFlashlight');

      // Toggle state locally
      isOn = !isOn;
      emit(SensorFlashlightToggled(isOn));
    } on PlatformException catch (e) {
      emit(SensorError("Platform error: ${e.message}"));
    } catch (e) {
      emit(SensorError("Unknown error: ${e.toString()}"));
    }
  }
}
