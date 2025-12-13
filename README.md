# Maple Quest - iOS App

A location-based social iOS application built with SwiftUI that connects to the Maple Quest Django backend.

## Features

- **Location Exploration**: Discover and visit landmarks across Canada
- **Photo Sharing**: Capture and upload photos at visited locations
- **Social Features**: Connect with friends and share your adventures
- **Achievements**: Earn points and unlock achievements for exploring
- **Profile Management**: Customize your profile and track your progress

## Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Active Maple Quest backend server (Refer to README in `/backend` for instructions)

### Setup

1. Open the `frontend` directory in Xcode
2. Update `APIConfig.swift` with your backend URL (if changed from default)
3. Build and run on simulator or device

### Configuration

The app connects to the Django backend at the URL specified in `APIConfig.swift`. Make sure the backend is running before testing the app.

## Development

### Running the App

1. Ensure backend is running (see `backend/README.md`)
2. Open project in Xcode
3. Select target device/simulator
4. Press the button to build and run

## Backend Integration

As mentioned above, this iOS app consumes the Maple Quest Django API. See the backend documentation for more information

For backend setup: `backend/README.md`
