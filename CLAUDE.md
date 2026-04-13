# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SoundVault is an iOS music library app built with SwiftUI, Core Data, and MVVM architecture — created as a technical interview assignment. The app is a multi-level music library (artists → albums → tracks).

## Build & Run

Open the project in Xcode:
```
open SoundVault/SoundVault.xcodeproj
```

Build and run via Xcode (⌘R) targeting a simulator or device. There is no separate CLI build step; `xcodebuild` can be used for CI:

```bash
# Build
xcodebuild -project SoundVault/SoundVault.xcodeproj -scheme SoundVault -sdk iphonesimulator build

# Run tests
xcodebuild test -project SoundVault/SoundVault.xcodeproj -scheme SoundVault -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

The app follows **MVVM** with SwiftUI + Core Data:

- **`SoundVaultApp.swift`** — app entry point; injects `NSManagedObjectContext` into the SwiftUI environment via `PersistenceController.shared`.
- **`Persistence.swift`** — wraps `NSPersistentContainer`; provides a `preview` singleton (in-memory store) for SwiftUI previews.
- **`SoundVault.xcdatamodeld`** — Core Data model. Currently has a placeholder `Item` entity; this should be replaced with the real music library schema (e.g. Artist, Album, Track).
- **`ContentView.swift`** — root view; currently a placeholder list. Real views should be built here following MVVM (ViewModels as `@ObservableObject` or using `@FetchRequest` directly for simple cases).

## Key Conventions

- Core Data fetch requests should use `@FetchRequest` in views for simple cases or be encapsulated in a ViewModel for complex/filtered queries.
- The `PersistenceController.preview` static is the standard way to supply sample data for `#Preview` blocks — add seed data there when the model evolves.
- `container.viewContext.automaticallyMergesChangesFromParent = true` is already set, so background context saves will propagate to the UI automatically.

## Behavioral guidelines to reduce common coding mistakes

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## CODE QUALITY STANDARDS

- No force-unwraps ( ! ) in view code
- No  try!  or  as!  outside of Core Data generated accessors
- Every  @FetchRequest  must declare explicit  sortDescriptors  — never use an empty array
- Add  // MARK: -  section comments in all files
- Use  guard let for optional unwrapping; never  if let x = x { }  with implicit shadowing in production code
- Avoid AnyView  — use  @ViewBuilder  with concrete types
- Use  Group { }  instead of  AnyView  for conditional view logic
