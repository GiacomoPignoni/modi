# Modi
![Modi icon](https://github.com/GiacomoPignoni/modi/blob/main/Images/icon.png)

Modi is a failed project I have built for my girlfriend. 
It was a mood diary with interaction with partner and possibility to read what you write only 1 year after.

It failed because, since I didn’t want to spent money, I was hosting the backend on Heroku Free Dyno, but starting November 28 2022, it’s no longer available. So I can’t host the backend anymore for free, and it’s not worth it to pay for some server because there were fewer than 10 active users.

So I decided to put the repository public to demonstrate how I made an actual public and working app with Flutter.

## Architetcure
This Flutter app uses an architecture made by me, it tries to copy the base architecture of Angular since I came from web development with Angular. 
After 1 year I can say it works well, but the classic Flutter architectures work better and they are more “Flutter style”. So I just abandoned this idea

## Tech Stack
- Flutter
- NodeJS as backend, expose rest API and use Firebase Admin API
- Firebase used to store data and authenticate the user

The app doesn’t access directly the Firebase Firestore database but it always calls an API on the NodeJS server.
Only authentication is handled directly with Firebase.

To build your own version you need to create a Firebase project and put the settings file in the Flutter app and also in the backend.

## Screenshots
![Screen 1](https://github.com/GiacomoPignoni/modi/blob/main/Images/screen_1.png)
![Screen 2](https://github.com/GiacomoPignoni/modi/blob/main/Images/screen_2.png)
![Screen 3](https://github.com/GiacomoPignoni/modi/blob/main/Images/screen_3.png)
