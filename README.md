# Voice-to-Text and Text-to-Voice Flutter App

## Overview
This project is a Flutter application that integrates Google's Speech-to-Text (STT) and Text-to-Speech (TTS) APIs, as well as the GPT-4 based conversational model. The application allows users to speak into their device's microphone, transcribes the audio into text, passes the text through a GPT-4 model to generate a response, and then converts this text-based response back to speech.

## Features
- Record audio using a simple button interface.
- Automatic transcription of recorded audio into text via Google's STT API.
- Dynamic text-based response generation using GPT-4.
- Conversion of text-based responses back into speech via Google's TTS API.
- Conversation context retention by keeping track of the last 5 messages.

## Requirements
- Flutter SDK
- Android SDK
- Google Cloud Credentials (for STT and TTS services)
- Internet connection
- OpenAI API key (for GPT-4 integration)

## Dependencies
To install the dependencies, run:
\```
flutter pub get
\```

List of dependencies used in the project:
- `http`: For API requests.
- `path_provider`: To get the directory path for storing audio files.
- `permission_handler`: To request permission for audio recording.
- `flutter_sound`: For audio recording and playback.

## Setup
1. Clone the repository:
\```
git clone https://github.com/your-repo/voice-to-text-and-text-to-voice-flutter-app.git
\```
2. Move your Google Cloud Credentials file (typically `google_api_service.json`) and OpenAI API key into your project directory.

3. Update the Google Cloud Credentials file path and OpenAI API key in your code.

4. Run the app:
\```
flutter run
\```

## How To Use
1. Press the "Start STT" button to initiate audio recording.
2. Speak your query or statement into the device's microphone.
3. Press the "Stop STT" button to stop the recording, which will then transcribe your audio to text.
4. The transcribed text will be displayed on the screen and passed through a GPT-4 model to generate a response.
5. The generated text-based response will be converted back to speech and played through your device's speaker.

## Known Issues
- The app may experience latency during the STT and TTS processes.
- The UI/UX could be improved for a more streamlined experience.

## Future Work
- Optimize the STT and TTS processes for faster response times.
- Implement user settings for adjusting STT and TTS configurations.
- Improve UI/UX design.

## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
