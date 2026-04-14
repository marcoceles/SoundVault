# SoundVault — iOS Technical Assignment

AI Prompts Used

## Project Setup

- **App name:** `SoundVault`
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** Core Data
- **Minimum deployment target:** iOS 17
- **No third-party dependencies**

---

## Core Data Schema

Define the following entities in `SoundVault.xcdatamodeld`.

### Playlist

| Attribute | Type | Notes |
|---|---|---|
| id | UUID | Required, default: `UUID()` |
| name | String | Required |
| artworkColor | String | Hex color string, e.g. `#FF5733` |
| createdAt | Date | Required |

### Song

| Attribute | Type | Notes |
|---|---|---|
| id | UUID | Required, default: `UUID()` |
| title | String | Required |
| artist | String | Required |
| duration | Double | Duration in seconds |
| trackNumber | Integer16 | Position in playlist |

### Relationships

- `Playlist` → `songs`: To-Many → `Song`, delete rule: Cascade
- `Song` → `playlist`: To-One → `Playlist`, delete rule: Nullify
- Inverse relationship properly set on both sides

---

## Core Data Stack

Create a `PersistenceController` (singleton) with:

- An `NSPersistentContainer` named `SoundVault`
- An in-memory store option for SwiftUI Previews
- A `save()` helper that only saves if `context.hasChanges`
- A static `preview` instance that pre-populates mock data

---

## Mock Data

Pre-populate at least 6 playlists, each containing at least 6 songs.

Suggested playlists:
  1.  Chill Vibes — ambient/lo-fi tracks
  2.  Workout Fuel — high-energy tracks
  3.  Deep Focus — instrumental tracks
  4.  Late Night Jazz — jazz standards
  5.  Road Trip Anthems — classic rock/pop
  6.  Indie Discoveries — indie tracks

Assign each playlist a distinct `artworkColor` hex string.
Implement mock seeding in `PersistenceController.preview` and also seed data on first launch in production via a 
`UserDefaults` flag with key `"hasSeededInitialData"`.

--- 

## Architecture

Use MVVM with lightweight ViewModels where needed. For simple list views, fetch directly using `@FetchRequest`. 
Use `@SectionedFetchRequest` or `NSFetchedResultsController` where sectioning or grouping adds value.                                                                                                                                           

Performance Rules
  1.  Use `@FetchRequest` with a predicate scoped to the parent playlist for the songs list — never fetch all songs and filter in memory.
  2.  Set `fetchBatchSize = 20` on all fetch requests with potentially large result sets.
  3.  Use `NSManagedObjectContext` on the main actor only; never pass managed objects across concurrency boundaries.
  4.  Avoid triggering faults inside list cells — only access attributes needed for display in the cell itself.
  5.  Use `.animation(.default, value: ...)` sparingly to avoid unnecessary diffing overhead.

---

## File Structure

SoundVault/
├── Persistence.swift
├── SoundVaultApp.swift
└── Views/
    ├── PlaylistListView.swift
    ├── PlaylistRowView.swift
    ├── SongListView.swift
    └── SongRowView.swift

Move all extensions into separate files

---

## App Structure & Navigation

Use a `NavigationStack`. Do not use `NavigationView`.

### Screen 1 — Playlist List (`PlaylistListView`)

- Displays all playlists using `@FetchRequest`, sorted by `createdAt` ascending.
- Each row shows:
    - A circular or rounded artwork square using the playlist’s `artworkColor`
    - A music note SF Symbol centered in the artwork
    - Playlist name in bold, using `.title3`
    - Song count subtitle: `"\(playlist.songsArray.count) songs"`
    - A chevron indicator
- Supports swipe-to-delete using Core Data cascade delete.
- Includes a toolbar `+` button to add a new playlist with a sheet and name text field.
- Shows an empty state with an animated waveform SF Symbol and the message: *"No playlists yet. Tap + to create one."*

### Screen 2 — Song List (`SongListView`)

- Receives a `Playlist` managed object through `NavigationLink`.
- Fetches songs using `@FetchRequest`
- Each row shows:
    - A track number badge in a circle
    - Song title as primary text
    - Artist name as secondary, muted text
    - Duration formatted as `m:ss`, for example `3:42`
- Highlights one randomly selected song as “Now Playing”, chosen on appear and stored in `@State`.
- Uses the playlist name as the navigation bar title.
- Uses large title mode.
- Supports swipe-to-delete for individual songs.
- Includes a toolbar `+` button to add a new song with fields for title, artist, and duration in seconds.

---

## UI Design Requirements

### Color & Theme

- Support both Light Mode and Dark Mode natively using `@Environment(\.colorScheme)`.
- Define a custom `AppTheme` struct or extension with semantic colors:
    - `AppTheme.background`
    - `AppTheme.surface`
    - `AppTheme.primaryText`
    - `AppTheme.secondaryText`
    - `AppTheme.accent`
- Use a vibrant teal accent color: `Color(red: 0.0, green: 0.6, blue: 0.65)`.
- Backgrounds should use layered surface colors, not flat white or black.

### Typography

- Use Dynamic Type.
- Never hardcode font sizes; always use semantic styles such as `.font(.title)` and `.font(.body)`.
- Playlist names: `.font(.title3).fontWeight(.semibold)`
- Song titles: `.font(.body).fontWeight(.medium)`
- Artist names: `.font(.subheadline).foregroundStyle(.secondary)`
- Durations: `.font(.caption).monospacedDigit()`

### Animations

- Playlist rows should use:

```swift
.transition(
    .asymmetric(
        insertion: .move(edge: .leading).combined(with: .opacity),
        removal: .opacity
    )
)
```

---

## VIEW MODELS

- Create ViewModels for all the views moving all the logic and functions related to core data persistence to the ViewModel.
- Make ViewModel @Observable and define a reference of it in the View. The view needs to react to the VM changes.

### Fix

- Is @Bindable really necessary? The viewModel is already @Observable.

---

## FIX

- When create a new song for a playlist I want that the number of song for that playlist updates accordingly. Currently, when I go back to the Playlist's List View it shows a non-updated count if a new song has been added.

- When edit a playlist from SongList View the changes need to reflect also on the Playlists List View accordingly.

- The pulse animation for the nowPlaying song stops working when selected another song. It works only for the first song when the view first appears.

---

## UI IMPROVEMENTS

- I noticed an empty state is missing for the playlist detail view when there are no songs. Use the same behaviour as per the Playlists List empty state.   

---

## IMPROVEMENTS

I want you to implement the following feature set in a clean, production-quality way, preserving the current architecture as much as possible:

### Goal
Add support for a custom playlist cover image selected from the device photo library.

### Requirements
- A playlist must support a custom cover image.
- The cover image must be selected when creating a playlist.
- The image should be persisted using Core Data.
- The current app uses SwiftUI and Core Data only, with no third-party libraries.
- Prefer native SwiftUI APIs for photo picking.

### Implementation details
1. Update the Core Data model:
   - Add a new optional attribute to `Playlist` called `coverImageData`
   - Type: Binary Data
   - Store enough data to render a thumbnail and a larger header image
   - Keep existing properties intact

2. Update playlist creation flow:
   - In the playlist creation sheet, add support for choosing an image from the photo library
   - Use `PhotosPicker`
   - Let the user preview the selected image before saving
   - Saving a playlist should persist:
     - name
     - artwork/cover image data
     - existing fields already used by the app

3. Implementation guidance:
   - Convert the selected image into `Data`
   - Use JPEG compression with reasonable quality
   - Keep the code clean and separated
   - Do not add UIKit wrappers if `PhotosPicker` is sufficient
   - If no image is selected, the app should fall back to the current visual placeholder UI

4. Code organization:
   - If needed, create dedicated helpers/extensions such as:
     - `Playlist+Extensions.swift`
     - `UIImage+Compression.swift`
     - `PlaylistCoverView.swift`
   - Keep views small and reusable

---

I want to enhance the Song List view so the selected playlist has a richer visual presentation.

## Goal
Show the playlist cover image at the top of `SongListView` with a polished, premium music-app style UI.

## Requirements
- The playlist cover image should be displayed prominently in `SongListView`
- The UI should feel refined and visually rich, not like a tutorial
- If the playlist has no custom image, show an elegant fallback placeholder
- The design should work in both Light Mode and Dark Mode

## Desired UI direction
- Add a header section at the top of `SongListView`
- The header should include:
  - playlist cover image
  - playlist name
  - optional metadata such as song count
- Make the header visually appealing:
  - layered background
  - subtle overlay or gradient
  - strong spacing and hierarchy
- Keep performance in mind for list rendering

## Technical constraints
- Do not break the current song fetching logic
- Do not fetch unnecessary data
- Avoid expensive image processing in every row render
- Keep the image rendering isolated in a reusable SwiftUI view if possible

## Implementation guidance
- Create a reusable component such as `PlaylistHeaderView`
- Use the stored Core Data image data and render it safely
- Convert `Data` to `UIImage` / `Image` in a controlled way
- Avoid repeating conversions unnecessarily
- Keep the existing song row layout unless a small improvement is justified

---

Editable Palylists

## Goal
Make playlists editable from `SongListView`.

## Requirements
- From `SongListView`, I need to be able to edit the current playlist
- I must be able to change:
  - playlist name
  - playlist cover image
- The edit UI should be presented from `SongListView`
- The image should be re-selectable from the device photo library
- Changes should persist immediately after save
- The updated header UI in `SongListView` should refresh correctly

## UX expectations
- Add an Edit action in the navigation bar or a contextually appropriate place
- Tapping Edit should present a sheet
- The sheet should be prefilled with the current playlist data
- Show the current cover image preview
- Allow replacing the image with a new one
- If appropriate, also allow removing the current image and falling back to placeholder UI

## Technical guidance
- Reuse as much code as possible between create and edit flows
- If useful, extract a shared form view for create/edit playlist
- Keep Core Data updates on the view context
- Avoid duplicating image conversion code
- Use `PhotosPicker`
- Handle optional image state carefully

## Suggested structure
- Shared `PlaylistFormView.swift` used by both add and edit flows

---

I want to refactor the current mock data setup so that mock/seed data is no longer hardcoded in Swift files and is instead loaded from a JSON file bundled with the app.

## Goal
Move mock data to JSON and load it from file for both:
- first-launch Core Data seeding
- SwiftUI preview/demo data

## Current situation
- The app currently seeds mock playlists and songs in Swift code inside `PersistenceController.preview` and/or first-launch seed logic
- I want this hardcoded mock data removed and replaced with a bundled JSON-based approach

## Requirements

### JSON source
- Create a JSON file in the app bundle, for example:
  - `SeedData/playlists.json`
- The JSON should contain all mock playlists and their songs
- Keep at least 6 playlists and at least 6 songs per playlist
- The structure should be clean and easy to extend

### Decoding layer
- Create Codable DTOs for decoding the JSON, for example:
  - `SeedPlaylistDTO`
  - `SeedSongDTO`
- Keep DTOs separate from Core Data managed objects
- Decode the JSON safely from the app bundle

### Core Data import
- After decoding, map DTOs into Core Data entities:
  - `Playlist`
  - `Song`
- Seed only when needed:
  - on first app launch
  - or when the store is empty
- Do not duplicate data on subsequent launches
- Preserve existing relationships between playlists and songs

### Preview support
- `PersistenceController.preview` should also load seed data from the same JSON file
- Avoid duplicating seed logic between preview and production seeding
- Create a shared import/seeding path if possible

### Architecture and file organization
Please structure the solution cleanly. Suggested files:
- `SeedData/playlists.json`
- `SeedModels/SeedPlaylistDTO.swift`
- `SeedModels/SeedSongDTO.swift`
- `SeedDataLoader.swift`
- `CoreDataSeeder.swift`
- updated `PersistenceController.swift`

### Implementation details
- Load the JSON from `Bundle.main`
- Use `JSONDecoder`
- If dates are needed, define a clear decoding strategy
- Keep the code testable and reusable
- Avoid `fatalError` unless truly justified for preview/dev-only paths
- Prefer throwing functions with proper error handling in production code
- Make sure the JSON file is included in target membership

### Additional expectations
- Remove the old hardcoded mock arrays from Swift files
- Add short comments only where helpful
- Keep the code production-quality and easy to review in an interview setting

---

## GIT

- Create a feature branch for the current development.
- Read all current changes and commit them in separated commits with meaningful messages.
- Create a PR for this feature branch with a summary of changes.

---