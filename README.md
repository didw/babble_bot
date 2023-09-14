# Voice-to-Text and Text-to-Voice Flutter App

## Overview
This project demonstrates a simple Flutter application that integrates Google's Speech-to-Text (STT) and Text-to-Speech (TTS) APIs. The application allows a user to record their voice and then transcribes it into text using Google's STT. It then uses a GPT-4 based model to generate a text-based response which is converted back into speech using Google's TTS API.

## Features
- Record audio with the press of a button.
- Automatic transcription of recorded audio into text.
- Generate a text-based response (currently hard-coded).
- Convert the text-based response into audio and play it.

## Requirements
- Flutter SDK
- Android SDK
- Google Cloud Credentials (for STT and TTS services)
- Internet connection

## Dependencies
To install the dependencies, run:
```
flutter pub get
```

List of dependencies used in the project:
- `http`: For API requests.
- `path_provider`: To get the directory path for storing audio files.
- `permission_handler`: To request permission for audio recording.
- `flutter_sound`: For audio recording and playback.

## Setup
1. Clone the repository:
    ```
    git clone https://github.com/your-repo/voice-to-text-and-text-to-voice-flutter-app.git
    ```
2. Move your Google Cloud Credentials file (typically `google_api_service.json`) into your project directory.

3. Update the Google Cloud Credentials file path in your code.

4. Run the app:
    ```
    flutter run
    ```

## How To Use
1. Press the "Start STT" button to start recording your voice.
2. Speak clearly into the microphone.
3. Press the "Stop STT" button to stop the recording and initiate the transcription process.
4. The transcribed text will be displayed, and a text-based response will be generated.
5. The text-based response will be converted into speech and played.

## Known Issues
- The app currently does not have a progress indicator for STT and TTS processes.
- The text-based response is currently hard-coded and does not utilize GPT-4.

## Future Work
- Implement GPT-4 for generating text-based responses.
- Add progress indicators for STT and TTS.
- Improve UI/UX.

## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
