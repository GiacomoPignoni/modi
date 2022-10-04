/* eslint-disable no-console */
const app = require("firebase/app");
const auth = require("firebase/auth");

const firebaseConfig = {
  apiKey: "AIzaSyCDwgtII468GDfUBsX4I6j_pJ-NmiZ4ZDI",
  authDomain: "modi---dev.firebaseapp.com",
  projectId: "modi---dev",
  storageBucket: "modi---dev.appspot.com",
  messagingSenderId: "21778963678",
  appId: "1:21778963678:web:c0f9c96d7d0bd43830b64f",
  measurementId: "G-DTN4WSBF5R",
};

const fireApp = app.initializeApp(firebaseConfig);

const fireAuth = auth.getAuth(fireApp);
auth.signInWithEmailAndPassword(fireAuth, "a@a.it", "asd321").then((userCredential) => {
  console.log(userCredential.user);
}).catch((error) => {
  console.log(error.code, error.message);
});
