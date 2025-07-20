import 'package:book_finder_app/features/sensor/cubit/sensor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Sensor Info")),
        body: Center(
          child: BlocBuilder<SensorCubit, SensorState>(
            builder: (context, state) {
              if (state is SensorLoading) {
                return const CircularProgressIndicator();
              } else if (state is SensorFlashlightToggled) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.isOn ? Icons.flashlight_on : Icons.flashlight_off,
                      size: 80,
                      color: state.isOn ? Colors.yellow : Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<SensorCubit>().toggleFlashlight(),
                      child: Text(state.isOn ? "Turn Off" : "Turn On"),
                    ),
                  ],
                );
              } else if (state is SensorError) {
                return Text("Error: ${state.message}");
              }

              return ElevatedButton(
                onPressed: () =>
                    context.read<SensorCubit>().toggleFlashlight(),
                child: const Text("Toggle Flashlight"),
              );
            },
          ),
        ),
      ),
    );
  }
}
