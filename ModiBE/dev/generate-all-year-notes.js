/* eslint-disable no-console */
const admin = require("firebase-admin");

function getDateString(date) {
  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, "0")}-${date.getDate().toString().padStart(2, "0")}`;
}

(async () => {
  const serviceAccount = require("../config/dev.firebase.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
  const userDoc = admin.firestore().collection("users").doc("FQtT4krxn2QGpNvQ88s1AKysS9s2");
  const notesCollection = userDoc.collection("notes");

  const now = new Date();
  let date = new Date(now.getFullYear(), 0, 1);

  console.log("Init process", `Start from ${getDateString(date)}`);
  while (date.getFullYear() === now.getFullYear()) {
    await notesCollection.add({
      d: getDateString(date),
      m: Math.floor(Math.random() * 4),
      t: "Test",
      u: Math.floor(Math.random() * 2) === 0 ? true : false,
    });

    console.log(`Added ${getDateString(date)}`);
    date = new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1);
  }

  console.log("Done");
})();
