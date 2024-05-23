# Todo Sync

This is a simple todo list application that allows you to add, edit, and delete tasks. It also allows you to mark tasks as complete or incomplete.

The purpose of this project is to demonstrate how the event sourcing pattern can be implemented to synchronize data with the server and affect multiple clients.

> The app is in Portuguese (Brazil).

## Technologies

- Flutter
- Firebase Auth (just for authentication, also with the server)
- Riverpod
- Realm
- ASP.NET (.NET 8) to build the REST API
- SQLite
- Docker

## Screenshots
| Home Page | Settings Page |
|-----------|---------------|
| ![HomePage](https://github.com/LuanRoger/todo_sync/blob/main/images/homepage.png) | ![SettingsPage](https://github.com/LuanRoger/todo_sync/blob/main/images/settings.png) |

### Demo
![QuickDemo](https://github.com/LuanRoger/todo_sync/blob/main/images/demo.gif)

## How to run

### Pre-requisites

- You must need a Firebase project setup with the Authentication service enabled.
- You also need the Firebase Admin SDK private key to run the server (`.json` file).
- Docker installed on your machine.
- This project allready cloned in your local machine.

### Step by step (API)

1. Build the API's Docker image

On the `./TodoAPI/` run the command:

```bash
docker build -t todoapi .
```

To build the Docker image.

2. Run the image

The name of the file of the Firebase Admin SDK private key must be `FirebaseAdminCredentials.json`. You can change the name of the file, but you need to change the `Docker run` command.

```bash
docker run --name todo-api -p 7063:8080 -d -e GOOGLE_APPLICATION_CREDENTIALS="/app/FirebaseAdminCredentials.json" todoapi
```

To access the API you can use the URL `http://localhost:7063`.

### Step by step (App)

1. Get the Fluter packages

```bash
flutter pub get
```

2. Generate the files (freezed and Realm)

**freezed**

```bash
dart run build_runner build
```

**Realm**

```bash
dart run realm generate
```

3. Run the app

It's recommended to run the app on a Android emulator or a physical device, since the app was just tested on Android.

```bash
flutter run
```
