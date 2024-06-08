import 'package:flutter/material.dart';
import 'package:medista_test/helper/face_detector_painter.dart';
import 'package:medista_test/services/websocket_service.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mediapipe_face_detection/google_mediapipe_face_detection.dart';
import 'package:camera/camera.dart';
import 'dart:developer' as devtools show log;

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  final GoogleMediapipeFaceDetection _faceDetection =
      GoogleMediapipeFaceDetection();
  bool isStarted = false;
  List<Rect> scanResults = [];
  late WebSocketService _webSocketService;
  String _connectionStatus = 'Disconnected';
  final String url = 'ws://localhost:8080';

  void connectWebSocket() {
    // Initializing WebSocket
    _webSocketService = WebSocketService(url);

    // Handling WebSocket connection
    _webSocketService.stream.listen((event) {
      setState(() {
        _connectionStatus = 'Connected';
      });
      devtools.log('Connection Opened');
    }, onError: (error) {
      setState(() {
        _connectionStatus = '${error.inner.message}';
      });
      devtools.log('Connection Error: ${error.inner.message}');
    }, onDone: () {
      if (_webSocketService.isConnected) {
        setState(() {
          _connectionStatus = 'Disconnected';
        });
        devtools.log('Connection Closed');
        _webSocketService.notConnected();
      }
    });
  }

  void initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize();

    // Loading face detection model
    await _faceDetection.load();
  }

  void _startDetection() async {
    while (isStarted) {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final results = await _faceDetection.processImage(inputImage);

      // Send image data to WebSocket
      final bytes = await image.readAsBytes();
      _webSocketService.sendData(bytes);

      if (mounted) {
        setState(() {
          scanResults = results;
        });
      }
    }
  }

  Widget buildResult() {
    final Size imageSize = Size(_controller!.value.previewSize!.width,
        _controller!.value.previewSize!.height);

    CustomPainter customPainter = FaceDetectorPainter(
      imageSize,
      scanResults,
      isStarted,
    );

    return CustomPaint(painter: customPainter);
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
    connectWebSocket();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    List<Widget> stackWidgetChildren = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection & Streaming'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Text(
                  'WebSocket Status: $_connectionStatus',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_controller != null) {
              stackWidgetChildren.add(
                Positioned(
                  top: 0,
                  left: 0,
                  width: size.width,
                  height: size.height,
                  child: Container(
                    child: _controller!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          )
                        : Container(),
                  ),
                ),
              );

              stackWidgetChildren.add(
                Positioned(
                  top: 0,
                  left: 0,
                  width: size.width,
                  height: size.height,
                  child: buildResult(),
                ),
              );
            }
            return Stack(
              children: stackWidgetChildren,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: MaterialButton(
        onPressed: () async {
          try {
            setState(() {
              isStarted = !isStarted;
            });
            _startDetection();
          } catch (e) {
            devtools.log(e.toString());
          }
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            !isStarted ? 'Start' : 'Stop',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
