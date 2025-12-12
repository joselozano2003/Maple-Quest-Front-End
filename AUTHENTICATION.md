# Authentication Implementation

This document describes the authentication system implemented in the Maple Quest iOS app.

## Overview

The app now includes a complete authentication system that integrates with the Django backend API. Users can register, login, and logout, with JWT tokens securely stored in the iOS Keychain.

## Components

### 1. AuthService (`Model/AuthService.swift`)

- Singleton service that manages authentication state
- Handles login, registration, and logout
- Manages JWT token refresh automatically
- Provides reactive state updates via `@Published` properties

### 2. KeychainService (`Model/KeychainService.swift`)

- Secure storage for JWT tokens and user data
- Uses iOS Keychain for sensitive data protection
- Handles access tokens, refresh tokens, and user profile data

### 3. Authentication Views

- **LoginView**: Email/password login form with show/hide password toggle
- **RegisterView**: User registration form with validation
- **SplashView**: Loading screen during app initialization

### 4. API Integration

- **APIConfig**: Centralized configuration for backend URL
- Automatic token refresh on API calls
- Error handling for authentication failures

## Usage

### Backend Configuration

Update the backend URL in `Model/APIConfig.swift`:

```swift
static let baseURL = "http://localhost:8000" // For local development
// or
static let baseURL = "https://aws-domain.com" // For production
```

### Authentication Flow

1. App starts with SplashView while checking stored credentials
2. If authenticated, shows main ContentView with TabView
3. If not authenticated, shows LoginView
4. Users can register new accounts or login with existing credentials
5. JWT tokens are automatically managed and refreshed
6. Users can logout from the Profile tab

### API Endpoints Used

- `POST /auth/login/` - User authentication
- `POST /auth/register/` - User registration
- `POST /auth/token/refresh/` - JWT token refresh
- `GET /auth/profile/` - Get user profile (future use)

## Security Features

- JWT tokens stored securely in iOS Keychain
- Automatic token refresh before expiration
- Secure password handling (never stored locally)
- Proper logout that clears all stored credentials
- Password visibility toggle for better UX

## Integration with Existing App

The authentication system integrates seamlessly with the existing app:

- ProfileView now includes a logout button
- ContentView receives user data from AuthService
- All views that need user data get it from the authenticated user
- Existing features like Friends, Map, and Achievements continue to work

## Future Enhancements

- Profile synchronization with backend
- Password reset functionality
- Biometric authentication (Face ID/Touch ID)
- Social login options
- Remember me functionality
