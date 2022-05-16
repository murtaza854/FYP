const prompt = require('prompt-sync')();
const dotenv = require('dotenv');
dotenv.config();
const mongoose = require('mongoose');
const User = require('./schema').user;

const firebaseFile = require('./firebase');
const firebaseAdmin = firebaseFile.admin;
const auth = firebaseFile.auth;

const { createUserWithEmailAndPassword, sendEmailVerification, updateProfile  } = require('firebase/auth');

const url = process.env.DATABASE_URL;

const createServer = async (callback) => {
    await mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true });
    console.log("Database connected!");
    let firstName = '';
    while (firstName === '') firstName = prompt('First name: ').trim();
    let lastName = '';
    while (lastName === '') lastName = prompt('Last name: ').trim();
    let email = '';
    while (email === '') email = prompt('Email: ').trim();
    let password = '';
    while (password === '' || password.length <= 6) password = prompt.hide('Password: ');
    const confirmPassword = prompt.hide('Confirm Password: ');
    if (password !== confirmPassword) {
        console.log('Passwords do not match... aboting!');
        process.exit(0);
    };
    const response = await createUserWithEmailAndPassword(auth, email, password);
    const user = response.user;
    sendEmailVerification(user);
    await updateProfile(user, { displayName: `${firstName} ${lastName}` });
    const newUser = new User({
        firstName: firstName,
        lastName: lastName,
        email: email,
        uid: user.uid
    });
    await newUser.save();
    console.log('Verification Email sent! Please verify to login');
    process.exit(0);

}

createServer();