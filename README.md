# PhotoGallery

An iOS application that fetches photos from a REST API, displays them in a scrollable list with thumbnails, persists data locally using Core Data, and supports editing titles and deleting records.

## Features

- **Photo List** — Browse photos with thumbnails and titles, loaded in paginated batches of 20
- **Image Caching** — Kingfisher integration for efficient image loading with retry and caching
- **Core Data Persistence** — Photos are cached locally; subsequent launches load from disk first
- **Edit Title** — Tap a photo to view in detail, edit the title, and save directly to Core Data
- **Swipe to Delete** — Delete photos via swipe action or detail view button, with confirmation alerts
- **Error & Empty States** — Graceful handling of network failures and empty data with retry support
- **Pagination** — Infinite scroll loads more photos as you reach the bottom of the list

## Architecture

```
PhotoGallery/
├── Model/
│   ├── GalleryImage.swift              # Decodable model
│   ├── PhotoEntity+CoreDataClass.swift # Core Data entity class
│   ├── PhotoEntity+CoreDataProperties.swift
│   └── PhotoContainer.xcdatamodeld    # Core Data schema
├── Service/
│   └── Network.swift                  # Network protocol, NetworkService, APIEndpoint
├── ViewModel/
│   └── GalleryViewModel.swift         # @MainActor ViewModel with CRUD operations
├── Views/
│   ├── GalleryImageView.swift         # List row: thumbnail + title
│   └── GalleryDetailView.swift        # Detail: full image, edit title, save/delete
├── ContentView.swift                  # Main list with pagination, swipe-delete, states
└── PhotoGalleryApp.swift              # App entry point
```

**Pattern:** MVVM with protocol-oriented networking

| Layer | Responsibility |
|-------|---------------|
| **Model** | Data structures + Core Data entities |
| **Service** | Generic, protocol-based network layer with response validation |
| **ViewModel** | Business logic, state management, Core Data CRUD |
| **Views** | UI only — no business logic |

## API

| Property | Value |
|----------|-------|
| Endpoint | `https://jsonplaceholder.typicode.com/photos` |
| Method | GET |
| Pagination | `?_page=1&_limit=20` |

## Requirements

- **iOS** 15.0+
- **Swift** 5+
- **Xcode** 14+
- **Dependencies:** [Kingfisher](https://github.com/onevcat/Kingfisher) (via SPM) for image caching

## Setup

1. Clone the repository
   ```bash
   git clone https://github.com/aryanarayantiwari/PhotoGallery.git
   cd PhotoGallery
   ```
2. Open `PhotoGallery.xcodeproj` in Xcode
3. Xcode will automatically resolve the Kingfisher SPM dependency
4. Select a simulator and press **⌘R** to build & run

## Key Design Decisions

- **Protocol-oriented networking** — `Network` protocol enables easy mocking for unit tests
- **`@MainActor` on ViewModel** — Ensures all `@Published` property updates happen on the main thread
- **Core Data as single source of truth** — After initial API fetch, all reads come from Core Data
- **`APIEndpoint` enum** — Clean, scalable URL construction with query parameters via `URLComponents`
- **No Alamofire** — Pure `URLSession` with HTTP status validation as required
