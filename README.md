# EnableX AI Voice Agent - Flutter Sample App

A Flutter sample application demonstrating an AI-powered voice agent for credit card sales. This app showcases real-time voice interaction capabilities using the EnableX Voice Bot SDK, featuring an intuitive animated UI with live speaking indicators.



## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.9.2 or higher
- **Dart SDK**: Compatible with Flutter 3.9.2+
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **EnableX Account**: You'll need a virtual number from EnableX

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/voice_bot_sample_app.git
   cd voice_bot_sample_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure your virtual number**
   
   Open `lib/voice_agent_screen.dart` and update the `virtualNumber` variable:
   ```dart
   var virtualNumber = "your_virtual_number_here";
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## ⚙️ Configuration

### Android Setup

The app requires microphone permissions. These are already configured in the Android manifest. Ensure you grant microphone permissions when prompted.

### iOS Setup

Add the following to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone for voice calls</string>
```

### EnableX Token Endpoint

The app fetches tokens from:
```
https://botsdemo.enablex.io/get-token/?phone={virtualNumber}
```

Make sure your virtual number is registered with EnableX and the token endpoint is accessible.

## 📱 Usage

1. **Launch the app** - The voice agent screen will be displayed
2. **Get Started** - Tap the "Get Started" button to initiate a connection
3. **Wait for connection** - The status will show "CONNECTING..." and then "CONNECTED"
4. **Interact with the agent** - Speak naturally; the app will show when you or the bot is speaking
5. **Mute/Unmute** - Use the microphone button to mute or unmute your audio
6. **Disconnect** - Tap "Disconnect" to end the call

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
└── voice_agent_screen.dart   # Main voice agent UI and logic

assets/
└── app_icon.png             # App icon

android/                     # Android-specific configuration
ios/                         # iOS-specific configuration
```

## 📦 Dependencies

- **enx_voice_bot**: ^0.1.1 - EnableX Voice Bot SDK for Flutter
- **http**: ^1.6.0 - HTTP client for API calls
- **permission_handler**: ^12.0.1 - Handle runtime permissions
- **flutter_launcher_icons**: ^0.14.4 - Generate app icons
- **cupertino_icons**: ^1.0.8 - iOS-style icons

## 🎨 UI Features

- **Animated Voice Agent Circle**: 
  - Outer pulse rings for visual feedback
  - Inner breathing circle with status text
  - Wave animation when bot is speaking
  
- **Status Text**: Dynamic status updates:
  - "READY" - Initial state
  - "CONNECTING..." - Establishing connection
  - "CONNECTED" - Call active
  - "BOT SPEAKING..." - Bot is talking
  - "YOU SPEAKING..." - User is talking

- **Control Buttons**:
  - Connect/Disconnect button
  - Mute/Unmute button (visible when connected)

## 🔧 Troubleshooting

### Connection Issues
- Verify your virtual number is correctly configured
- Check internet connectivity
- Ensure the EnableX token endpoint is accessible

### Permission Issues
- Grant microphone permissions when prompted
- Check app settings if permissions were denied

### Build Issues
- Run `flutter clean` and `flutter pub get`
- Ensure all prerequisites are installed
- Check Flutter doctor: `flutter doctor`

## 🌐 Platform Support

- ✅ Android
- ✅ iOS


## 📝 License

This project is a sample application. Please refer to EnableX's terms of service for SDK usage.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues related to:
- **EnableX SDK**: Contact EnableX support
- **App Issues**: Open an issue on GitHub

## 🙏 Acknowledgments

- EnableX for providing the Voice Bot SDK
- Flutter team for the amazing framework

---

Made with ❤️ using Flutter
