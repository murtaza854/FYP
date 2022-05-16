const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');
dotenv.config();
const app = express();
const http = require('http').createServer(app);

const firebaseFile = require('./firebase');
const firebase = firebaseFile.firebase;

const {
    DATABASE_URL,
    COOKIE_SECRET,
    API_URL1,
    API_URL2,
    // API_URL3,
    PORT,
} = process.env;

const url = DATABASE_URL;
const port = PORT;

const createServer = async (callback) => {
    await mongoose.connect(url, { useNewUrlParser: true, useUnifiedTopology: true });

    console.log("Database created!");

    app.use(bodyParser.urlencoded({ extended: true }));
    app.use(bodyParser.json());

    app.use(cookieParser(
        COOKIE_SECRET
    ));
    app.use(cors({
        credentials: true,
        // origin: [API_URL1, API_URL2]
        // origin: [API_URL3]
        origin: '*'
    }));
    app.use(express.static('./build'));

    const adminRoutes = require('./routes/admin');
    const userRoutes = require('./routes/user');
    const organizationRoutes = require('./routes/organization');
    const ambulanceTypeRoutes = require('./routes/ambulanceType');
    const ambulanceRoutes = require('./routes/ambulance');

    app.use('/api/admin', adminRoutes);
    app.use('/api/user', userRoutes);
    app.use('/api/organization', organizationRoutes);
    app.use('/api/ambulanceType', ambulanceTypeRoutes);
    app.use('/api/ambulance', ambulanceRoutes);

    // app.get('/', (req, res) => {
    //     res.send('Tezz');
    // });

    app.get('/api/logged-in', async (req, res) => {
        try {
            const admin = firebase.auth().currentUser;
            if (admin) {
                const displayName = admin.displayName;
                const email = admin.email;
                const emailVerified = admin.emailVerified;
                res.json({ data: { displayName, email, emailVerified } });
            } else res.json({ data: null })
        } catch (error) {
            res.json({ data: null, error: error });
        }
    });
    // app.get('*', function (req, res) {
    //     res.sendFile(path.resolve('./build/index.html'));
    // });

    app.listen(port, () => {
        console.log(`Example app listening at http://localhost:${port}`);
    });
}

createServer();