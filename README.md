# 3rd-party framework example

## Architecture

The UI is owned by a separate framework, **MyUI**, and consumed by **MyApp** as a pre-built `MyUI.xcframework` binary. MyApp never sees MyUI's source — it only links against the compiled framework, so the SwiftUI views and presentation logic stay encapsulated inside MyUI.

```
┌───────────────────────────────────────────────────────────────────────────┐
│  MyApp  (UIKit app, source)                                               │
│                                                                           │
│    ViewController                                                         │
│      └── "Show SwiftUI"  → MyUI.show()                                    │
│      └── "Show wrapped"  → MyUI.showWrapped()                             │
│                                                                           │
│    Only sees:  public enum MyUI { show(); showWrapped() }                 │
│    Cannot see: SwiftUIView, Presenter, MyUIView, MyUIWindow, …            │
└──────────────────────────────┬────────────────────────────────────────────┘
                               │ links + embeds
                               ▼
┌───────────────────────────────────────────────────────────────────────────┐
│  MyUI.xcframework  (binary, no source)                                    │
│                                                                           │
│    public enum MyUI                ← public surface                       │
│      ├── show()                                                           │
│      └── showWrapped()                                                    │
│                                                                           │
│    internal:                                                              │
│      ├── SwiftUIView               ← the SwiftUI content                  │
│      ├── Presenter                 ← owns a dedicated UIWindow            │
│      ├── MyUIWindow                ← UIWindow subclass for the modal      │
│      └── MyUIView                  ← UIView wrapper used by showWrapped() │
└───────────────────────────────────────────────────────────────────────────┘
```

### Getting started

1. Clone the repo.
2. Open `a.xcworkspace`.
2. Build `MyApp` target. This will also build the `MyUI` framework.
3. Run and start a cobrowse session using [redaction playground](https://cobrowse.io/playground).
4. *Show view* shows how it is today.
5. *Show wrapped* shows that if the `SwiftUI` view is wrapped in a custom `UIView` that can be seen in the redaction playground.


### Building the MyUI framework

MyApp's shared scheme has a **pre-build action** that runs before any Xcode build phase:

1. If `MyUI/MyUI.xcframework` already exists, skip archiving.
2. Otherwise, archive MyUI for iOS device + iOS Simulator and produce `MyUI/MyUI.xcframework` via `xcodebuild -create-xcframework`.

This means cloning the repo and pressing **Run** in Xcode is enough, no manual bootstrap step.

### Why a separate framework?

This mirrors how a real third-party SDK ships: customers receive a binary `.xcframework` and link against its public API. MyApp here plays the role of "customer app" — proving that the SwiftUI presentation in MyUI is genuinely opaque to the consumer, which is the precondition for demonstrating things like Cobrowse class-based redaction targeting `MyUIView`.
