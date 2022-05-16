const router = require('express').Router();
const Admin = require('../schema').admin;
const dotenv = require('dotenv');
const firebaseFile = require('../firebase');
const auth = firebaseFile.auth;
// const firebaseAdmin = firebaseFile.admin;
const { signInWithEmailAndPassword, signOut } = require('firebase/auth');
dotenv.config();

router.get('/getAllAdmins', async (req, res) => {
    try {
        const admins = await Admin.find();
        res.status(200).json({ data: admins });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/login', async (req, res) => {
    try {
        const response = await signInWithEmailAndPassword(auth, req.body.email.name, req.body.password.name);
        const admin = response.user;
        const displayName = admin.displayName;
        const email = admin.email;
        const emailVerified = admin.emailVerified;
        res.json({ data: { displayName, email, emailVerified } });
    } catch (error) {
        console.log(error);
        res.json({ data: null, error: error });
    }
});

router.post('/logout', async (req, res) => {
    try {
        await signOut(auth);
        res.json({ loggedIn: false });
    } catch (error) {
        res.json({ loggedIn: false, error: error });
    }
});

module.exports = router;