# Restful API Demo App

A Flutter app that consumes [restful-api.dev](https://restful-api.dev) with full CRUD support.

---

## Stack

- **Flutter** + **Provider** (MVVM)
- **http** package
- **restful-api.dev** public API

---

## Setup

```bash
git clone https://github.com/Gpaqsa/FlutterCRUD.git
cd FLUENT_CRUD
flutter pub get
flutter run
```

---

## Screens

- **List** — view all objects, swipe left to delete, pull to refresh
- **Detail** — view all object data, edit or delete
- **Form** — create or edit objects with dynamic key/value fields

---

## Project Structure

```
lib/
├── main.dart
├── core/
│   └── constants.dart
|   ├── theme.dart
├── data/
│   ├── models/object_model.dart
│   └── services/api_service.dart
├── viewmodels/
│   └── objects_viewmodel.dart
└── views/
    ├── list_screen.dart
    ├── detail_screen.dart
    └── form_screen.dart
```

---

## API

Base URL: `https://api.restful-api.dev`

| Method | Endpoint | Action |
|--------|----------|--------|
| GET | `/objects` | List all |
| GET | `/objects/{id}` | Get one |
| POST | `/objects` | Create |
| PUT | `/objects/{id}` | Update |
| DELETE | `/objects/{id}` | Delete |
