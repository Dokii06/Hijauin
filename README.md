# Hijauin

A Flutter application for managing waste deposits and tracking points.  
This app is designed to help users deposit waste, view their deposit history, and track earned points.

## Features

- User account management (view and edit profile, change address)
- Deposit waste and track points
- View deposit history
- Simple and clean UI with summary cards

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK installed ([Flutter Installation Guide](https://docs.flutter.dev/get-started/install))
- A device or emulator to run the app
- Access to the Hijauin API ([GitHub Repository](https://github.com/Kamal1202/Hijauin-Api))

### Installing

1. Clone this repository:
   ```bash
   git clone https://github.com/Kamal1202/Hijauin-Flutter.git
   cd Hijauin-Flutter
2. Install dependencies
   ```bash
   flutter pub get
3. Configure the API base URL in lib/services/api_service.dart:
   ```bash
   static const String baseUrl = 'http://<your-server-ip>:8000/api';
  
4. Run the app
   ```
   flutter run

### API

The app uses a separate backend API hosted here:
Hijauin API Repository [GitHub Repository](https://github.com/Kamal1202/Hijauin-Api)

Make sure the API server is running and accessible from your device/emulator.
