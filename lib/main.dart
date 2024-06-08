import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:medista_test/screens/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraDescription? firstCamera;
  try {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  } on CameraException catch (e) {
    devtools.log(e.toString());
  }
  runApp(
    MaterialApp(
      title: 'Medista Face Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyApp(camera: firstCamera),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription? camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return camera != null ? CameraScreen(camera: camera!) : const CameraError();
  }
}

class CameraError extends StatelessWidget {
  const CameraError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        centerTitle: true,
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No camera found! Please connect a web cam and try again later!',
          ),
        ],
      ),
    );
  }
}
