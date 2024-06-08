# medista_test

A Flutter web application for face detection and streaming video.

# Building and Running the Flutter Application

## Prerequisites:
Before you begin, ensure you have the following installed:
- **Flutter SDK:** Follow the official Flutter installation instructions for your operating system.
- **Dart SDK:** Flutter requires the Dart SDK. It's included with the Flutter SDK, so you don't need to install it separately.
- **Android Studio/VS code or Xcode:** Depending on whether you're targeting Android or iOS, you'll need either Android Studio/VS code or Xcode installed.
## Getting Started:
1. Clone the repository:
	```
	git clone https://github.com/shivangsorout/face-detection_webapp.git
	```
2. Navigate to the project directory:
	```
	cd <project_directory>
	```
3. Install dependencies:
	```
	flutter pub get
	```
## Set Up and Run the Mock WebSocket Server:
1. Navigate to the mock_server directory:
   ```
   cd mock_server
   ```
2. Ensure Node.js and npm are installed. If not, download and install them from [Node.js](https://nodejs.org/en).

3. Start the WebSocket server:
   ```
   node index.js
   ```
You should see the following output:
   ```
   WebSocket server is running on ws://localhost:XXXX
   ```

## Run the Flutter Web Application:
1. Go back to the root directory of the project:
  ```
  cd ..
  ```

2. Run the Flutter web application:
 ```
 flutter run -d {ANY_BROWSER}
 ```

## Troubleshooting

- If the webcam is not accessible, ensure that your browser has permission to access the webcam.
- If you encounter the following issue:
  ```
  CameraException(cameraNotReadable, The camera is not readable due to a hardware error that prevented access to the device.)
  ```
  Uninstall applications like OBS and other similar software to resolve this issue.


By following these instructions, you'll be able to build, run, and configure this Flutter web application.

