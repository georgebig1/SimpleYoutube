
# SimpleYoutube

## Overview
SimpleYoutube is a lightweight, highly customizable YouTube client for iOS. It is built with Swift and follows the MVVM architecture, providing a clean and responsive user experience. This project utilizes YouTube's RESTful API for fetching and displaying video content.

## Features
- **Video Playback** - Stream YouTube videos with integrated video player.
- **Channel Details** - Fetch and display channel information.
- **Playlist Management** - Access and manage video playlists.
- **Responsive UI** - Optimized for various iOS screen sizes using SnapKit for layout.
- **Local Caching** - Implement basic caching for faster loading and offline access.
- **Data Protection** - Ensure sensitive user data is handled securely.
- **Networking Layer** - Modular, flexible API layer for managing network requests and responses.
- **Error Handling** - Robust error handling with clear user feedback.

## Project Structure
```
SimpleYoutube/
├── AppDelegate.swift          # App lifecycle management
├── SceneDelegate.swift        # Scene lifecycle management
├── Config.xcconfig            # Configuration settings
├── Home/
│   ├── HomeViewController.swift   # Main view controller for video listing
│   ├── HomeViewModel.swift        # ViewModel for managing video data
│   ├── HomeTableViewCell.swift    # Custom table cell for video display
│   └── HomeCellViewModel.swift    # Cell ViewModel for individual video items
├── VideoPlayer/
│   ├── VideoPlayerViewController.swift   # Video playback controller
│   └── VideoPlayerViewModel.swift        # ViewModel for managing video player state
├── Common/
│   ├── AppConfig.swift         # Centralized configuration management
│   └── MVVM/
│       ├── BaseViewController.swift  # Base class for view controllers
│       ├── BaseViewModel.swift       # Base class for view models
│       └── BaseView.swift            # Base class for reusable views
└── API/
    ├── YoutubeApiRequest+Channels.swift  # Channel API requests
    ├── YoutubeApiRequest+Playlists.swift # Playlist API requests
    ├── YoutubeApiRequest+Videos.swift    # Video API requests
    ├── RequestCore/
    │   ├── YoutubeApiRequest.swift       # Core API request handling
    │   ├── YoutubeApiRequest+ApiErrorDecision.swift # Error handling
    │   └── YoutubeApiRequest+ApiParseResultDecision.swift # Response parsing
    └── DataModels.swift  # Data structures for API responses
```

## Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/georgebig1/SimpleYoutube.git
   cd SimpleYoutube
   ```
2. Open the project in Xcode:
   ```bash
   open SimpleYoutube.xcodeproj
   ```
3. Install required dependencies using Swift Package Manager:
   ```bash
   swift build
   ```
4. Run the project on a simulator or a real device.

## API Key Configuration
Replace the API key in the `Config.xcconfig` file:
```
YOUTUBE_API_KEY=your_api_key_here
```
Ensure you have a valid YouTube API key from the Google Developer Console.

## Usage
- **Home Screen** - Displays a list of popular YouTube videos.
- **Video Player** - Tap a video to start playback.

## Testing
To run the unit tests for this project, follow these steps:
1. Open the project in Xcode.
2. Select the test target from the scheme dropdown.
3. Press `Cmd + U` to run all unit tests.

Ensure that you have configured the API key correctly before running tests, as some tests may involve network requests.

## Technologies Used
- **Swift** - Main programming language
- **SnapKit** - For auto layout
- **MVVM Architecture** - For organized code structure
- **URLSession** - For network communication
- **Swift Package Manager (SPM)** - For dependency management
