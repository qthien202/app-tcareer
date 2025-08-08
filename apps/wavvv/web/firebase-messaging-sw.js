importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyBa2suLLiuvDmkTisxPg1oxxYojKx40zhw",

  authDomain: "tcareer-4fa7d.firebaseapp.com",

  databaseURL:
    "https://tcareer-4fa7d-default-rtdb.asia-southeast1.firebasedatabase.app",

  projectId: "tcareer-4fa7d",

  storageBucket: "tcareer-4fa7d.appspot.com",

  messagingSenderId: "353946571533",

  appId: "1:353946571533:web:f540d00c325bb1d272d644",

  measurementId: "G-JRVZ98QJCR",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((payload) => {
  console.log("Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png",
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});
