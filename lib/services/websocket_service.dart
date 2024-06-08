import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as devtools show log;

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;
  bool _isConnected = false;

  Stream get stream => _channel.stream;
  bool get isConnected => _isConnected;

  WebSocketService(this.url) {
    _connect();
  }

  void notConnected() {
    _isConnected = false;
  }

  void _connect() async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    try {
      await _channel.ready;
      _isConnected = true;
    } on WebSocketChannelException catch (error) {
      devtools.log('WebSocket connection error: ${error.message}');
      _isConnected = false;
    }
  }

  void sendData(dynamic data) {
    if (_isConnected) {
      _channel.sink.add(data);
    } else {
      devtools.log('WebSocket is not connected. Cannot send data.');
    }
  }

  void close() {
    _channel.sink.close();
  }
}
