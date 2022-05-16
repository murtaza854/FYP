const { initializeApp } = require('firebase/app');
const { getAuth } = require('firebase/auth');
const admin = require("firebase-admin");

const {
  API_KEY,
  AUTH_DOMAIN,
  PROJECT_ID,
  STORAGE_BUCKET,
  MESSAGE_SENDER_ID,
  APP_ID,
  FIREBASE_SDK_PATH
} = process.env;

initializeApp({
  apiKey: API_KEY,
  authDomain: AUTH_DOMAIN,
  projectId: PROJECT_ID,
  storageBucket: STORAGE_BUCKET,
  messagingSenderId: MESSAGE_SENDER_ID,
  appId: APP_ID
});

const serviceAccount = require(FIREBASE_SDK_PATH);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
const auth = getAuth();


module.exports = {
  admin,
  auth
}