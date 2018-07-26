# toledotechevents

Business logic and utilities for the Toledo Tech Events applications.

This package's structure utilizes the `simple framework` for cross-platform apps, which combines a straightforward file structure and the BLoC (Business Logic Component) architecture pattern.


## Files

### Top level files

Top-level library files should be filled in and expanded upon to fulfill business requirements.

File | Purpose
-|-
`config.dart` | Contains build configuration such as build flavor and backend server URLs.
`pages.dart` | Declares the app's `Page`s and corresponding `Route`s.
`theme.dart` | Colors, font, and other theme data.
`layout.dart` | Describes how pages are layed out, taking the `Page`, `Display`, and `Theme` into consideration.

### `BLoC files`

The `bloc/` directory contains classes for implementing the BLoC architecture, which act as view presenters, connecting views and user events to underlying models and services.

### `model/`

Contains the business's data models.

### `internal/`

For private code that is managed by a separate repo.

### `util/`

Utility classes devoid of any one project's business logic.