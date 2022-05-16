const router = require('express').Router();
const User = require('../schema').user;
const Request = require('../schema').request;
const EmergencyContact = require('../schema').emergencyContact;
const dotenv = require('dotenv');
const Organization = require('../schema/organization');
const crypto = require('crypto');
dotenv.config();

const firebaseFile = require('../firebase');
const firebaseAdmin = firebaseFile.admin;
const { signOut, getAuth, createUserWithEmailAndPassword } = require('firebase/auth');
const { FirstAidTips } = require('../schema');

const auth = getAuth();

const {
    API_KEY_BEARER,
} = process.env;

verifyToken = (req, res, next) => {
    const bearerHeader = req.headers['authorization'];
    if (typeof bearerHeader !== 'undefined') {
        const bearer = bearerHeader.split(' ');
        const bearerToken = bearer[1];
        if (bearerToken === API_KEY_BEARER) {
            req.token = bearerToken;
            next();
        } else {
            const error = new Error('Unauthorized');
            error.status = 403;
        }
    } else {
        const error = new Error('Unauthorized');
        error.status = 403;
    }
}

router.get('/getAllUsers', async (req, res) => {
    try {
        const users = await User.find();
        const data = [
            {
                _id: 1,
                firstName: 'John',
                lastName: 'Doe',
                email: 'john.doe@tezz.com',
                contactNumber: '+923334567890',
                accountSetup: true,
                firebaseUID: '1234567890',
                role: 'Driver',
                isActive: true,
                medicalCard: {},
                trips: [
                    {
                        _id: 1,
                        responseTime: 7,
                        commuteTime: 25,
                        distanceTravelledToPatient: 10,
                        distanceTravelledToDestination: 100,
                        startLocationFromAcceptance: {
                            name: 'Kathmandu',
                            latitude: 24.861330511134447,
                            longitude: 67.02928348779203
                        },
                        startLocation: {
                            name: 'Place A',
                            latitude: 24.861330511134447,
                            longitude: 67.02928348779203
                        },
                        endLocation: {
                            name: 'Place B',
                            latitude: 24.861330511134447,
                            longitude: 67.02928348779203
                        },
                        startTimeFromAcceptance: new Date('2021-12-15T15:14:39.806Z'),
                        startTime: new Date('2021-12-15T15:21:39.806Z'),
                        endTime: new Date('2021-12-15T15:46:39.806Z'),
                        patient: {
                            _id: 1,
                            firstName: 'John',
                            lastName: 'Doe',
                        },
                        ambulance: {
                            _id: 1,
                            numberPlate: 'ABC123',
                        },
                    },
                ],
                addresses: [],
                emergencyContacts: [],
                numberOfAcceptedTrips: 25,
                numberOfRejectedTrips: 5,
                numberOfCancelledTrips: 5,
                numberOfCompletedTrips: 15,
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                _id: 2,
                firstName: 'John',
                lastName: 'Doe',
                email: 'john.doe@tezz.com',
                contactNumber: '+923334567890',
                accountSetup: true,
                firebaseUID: '1234567890',
                role: 'Patient',
                isActive: true,
                medicalCard: {
                    _id: 1,
                    age: 25,
                    bloodGroup: 'A+',
                    height: 175,
                    weight: 75,
                    allergies: [
                        {
                            name: 'Peanuts',
                            severity: 'Mild',
                            reaction: 'Nausea',
                        },
                        {
                            name: 'Tomatoes',
                            severity: 'Mild',
                            reaction: 'Nausea',
                        },
                        {
                            name: 'Eggs',
                            severity: 'Low',
                            reaction: 'Nausea',
                        }
                    ],
                    medicalHistories: [
                        {
                            date: new Date('2021-12-15T15:14:39.806Z'),
                            description: 'Heart Surgery',
                            doctor: 'Dr. John Doe',
                            hospital: 'Hospital XYZ',
                        },
                    ],
                    medications: [
                        {
                            name: 'Aspirin',
                            dosage: '500mg',
                            frequency: 'Daily',
                        },
                        {
                            name: 'Paracetamol',
                            dosage: '500mg',
                            frequency: 'Daily',
                        },
                        {
                            name: 'Ibuprofen',
                            dosage: '500mg',
                            frequency: 'Daily',
                        }
                    ],
                    vaccinations: [
                        {
                            name: 'Hepatitis B',
                            date: new Date('2021-12-15T15:14:39.806Z'),
                            doctor: 'Dr. John Doe',
                            hospital: 'Hospital XYZ',
                        },
                    ],
                    familyHistories: [
                        {
                            name: 'Father',
                            description: 'Heart Disease',
                        },
                        {
                            name: 'Mother',
                            description: 'Diabetes',
                        },
                    ],
                    notes: [
                        {
                            name: 'Appointment',
                            date: new Date('2021-12-15T15:14:39.806Z'),
                            description: 'Heart Surgery',
                        },
                    ],
                },
                trips: [],
                addresses: [
                    {
                        addressLine1: 'House No. 1',
                        addressLine2: 'Road No. 1',
                        longitude: 24.861330511134447,
                        latitude: 67.02928348779203,
                        landmark: 'Near to XYZ',
                        city: 'Kathmandu',
                        state: 'Bagmati',
                        zipCode: '12345',
                    },
                ],
                emergencyContacts: [
                    {
                        user: {
                            _id: 1,
                            firstName: 'John',
                            lastName: 'Doe',
                        },
                        relationship: 'Father',
                        isActive: true,
                    },
                ],
                createdAt: new Date(),
                updatedAt: new Date(),
            },
            {
                _id: 3,
                firstName: 'John',
                lastName: 'Doe',
                email: 'john.doe@tezz.com',
                contactNumber: '+923334567890',
                accountSetup: false,
                firebaseUID: '1234567890',
                role: 'Patient',
                isActive: true,
                medicalCard: {},
                trips: [],
                addresses: [],
                emergencyContacts: [],
                createdAt: new Date(),
                updatedAt: new Date(),
            }
        ]
        res.status(200).json({ data: data });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.get('/getPatientList', verifyToken, async (req, res) => {
    try {
        const requests = await Request.find({ sender: req.query.email });
        const users = await User.find({
            email: { $ne: req.query.email },
        });
        let data = requests.map(request => {
            const user = users.find(user => user.email.toString() !== request.receiver.toString());
            return user;
        });
        if (data.length === 0) data = users;
        res.status(200).json({ data: data });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.get('/sendRequest', verifyToken, async (req, res) => {
    try {
        console.log(req.query);
        const request = await new Request({
            sender: req.query.sender,
            senderFirstName: req.query.senderFirstName,
            senderName: req.query.senderName,
            receiverFirstName: req.query.receiverFirstName,
            receiver: req.query.receiver,
            receiverName: req.query.receiverName,
            relationship: req.query.relationship,
        });
        await request.save();
        res.status(200).json();
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/acceptRequest', verifyToken, async (req, res) => {
    try {
        // const request = await Request.findById(req.body.id);
        // request.status = true;
        // await request.save();
        const user1 = await User.findOne({ email: req.body.sender });
        const user2 = await User.findOne({ email: req.body.receiver });
        const emergencyContact = await new EmergencyContact({
            user1: user1._id,
            user2: user2._id,
            user1RelationToUser2: req.body.firstRelationship,
            user2RelationToUser1: req.body.relationship,
        });
        await emergencyContact.save();
        const emergencyContactDB = await EmergencyContact.findById(emergencyContact._id).populate('user1').populate('user2');
        // const requests = await Request.find({ receiver: request.receiver, status: false });
        res.status(200).json({ emergencyContact: emergencyContactDB });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/deleteRequest', verifyToken, async (req, res) => {
    try {
        await Request.deleteOne({ _id: req.body.id });
        const requests = await Request.find({ receiver: req.body.receiver, status: false });
        res.status(200).json({ requests: requests });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/getID', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        res.status(200).json({ _id: user._id });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-phone-number', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        user.contactNumber = req.body.contactNumber;
        await user.save();
        res.status(200).json({ output: true });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-medicalCard', verifyToken, async (req, res) => {
    try {
        const {
            email,
            gender,
            dateOfBirth,
            height,
            weight,
            bloodGroup,
            primaryMedicalConditions,
            allergies,
            vaccinations,
            familyHistory,
            notes
        } = req.body
        const user = await User.findOne({ email: email });
        const medicalCard = {
            gender,
            dateOfBirth,
            bloodGroup,
            height,
            weight,
            primaryMedicalConditions,
            allergies,
            vaccinations,
            familyHistory,
            notes
        };
        user.medicalCard = medicalCard;
        user.accountSetup = true;
        await user.save();
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/add-driver', async (req, res) => {
    try {
        const password = crypto.randomBytes(10).toString('hex');
        const response = await createUserWithEmailAndPassword(auth, 'murtazafaisal744@gmail.com', password);
        const organization = await Organization.findOne({ name: 'Organization A' });
        const user = await new User({
            firstName: 'John',
            lastName: 'Doe',
            email: 'murtazafaisal744@gmail.com',
            contactNumber: '3146397499',
            firebaseUID: response.user.uid,
            role: 'Driver',
            passwordCreated: false,
            tempPassword: password,
            trips: [],
            ambulances: [],
            organization,
            addresses: [],
            emergencyContacts: [],
        });
        await signOut(auth);
        await user.save();
        console.log(password);
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/password-created', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUID: req.body.uid });
        user.passwordCreated = true;
        user.tempPassword = null;
        await user.save();
        res.status(200).json({ data: user });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-availaleForWork', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        user.availableForWork = req.body.availableForWork;
        await user.save();
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/signup', verifyToken, async (req, res) => {
    try {
        console.log(req.body);
        const {
            firstName,
            lastName,
            email,
            uid,
        } = req.body;
        const user = await new User({
            firstName,
            lastName,
            email,
            firebaseUID: uid,
            role: 'Patient',
            trips: [],
            addresses: [],
            emergencyContacts: [],
            ambulances: []
        });
        await user.save();
        console.log(user);
        res.status(200).json({ data: user });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/update-user-name', async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        user.firstName = req.body.firstName;
        user.lastName = req.body.lastName;
        await user.save();
        res.status(200).json({ data: user });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/save-address', verifyToken, async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        const address = {
            label: req.body.label,
            addressLine1: req.body.addressLine1,
            addressLine2: req.body.addressLine2,
            landmark: req.body.landmark,
            latitude: req.body.latitude,
            longitude: req.body.longitude
        };
        user.addresses.push(address);
        await user.save();
        res.status(200).send(address);
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.get('/get-first-aid-tips', verifyToken, async (req, res) => {
    try {
        const tips = await FirstAidTips.find({});
        res.status(200).send(tips);
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/get-logged-in-user', verifyToken, async (req, res) => {
    try {
        const {
            uid
        } = req.body;
        const user = await User.findOne({ firebaseUID: uid });
        if (!user) {
            res.status(404).json({ error: 'User not found' });
        } else {
            const requests = await Request.find({ receiver: user.email, status: false });
            const acceptedRequests = await Request.find({ sender: user.email, status: true, seenAfterAcceptanceFrom: false });
            const emergencyContacts = await EmergencyContact.find({
                $or: [
                    { user1: user._id },
                    { user2: user._id },
                ],
            }).populate('user1').populate('user2');
            const data = user;
            // const data = {
            //     _id: user._id,
            //     firstName: user.firstName,
            //     lastName: user.lastName,
            //     email: user.email,
            //     contactNumber: user.contactNumber,
            //     role: user.role,
            //     isActive: user.isActive,
            //     accountSetup: user.accountSetup,
            //     emergencyContacts: emergencyContacts,
            //     requests: requests,
            //     acceptedRequests: acceptedRequests,
            // };
            data['requests'] = requests;
            data['acceptedRequests'] = acceptedRequests;
            // data['addresses'] = [
            //     {
            //         label: 'Home',
            //         addressLine1: 'House No. 1',
            //         addressLine2: 'Road No. 1',
            //         longitude: 20.861330511134447,
            //         latitude: 67.02928348779203,
            //         landmark: 'Near to XYZ',
            //         city: 'Kathmandu',
            //         state: 'Bagmati',
            //         zipCode: '12345',
            //     },
            //     {
            //         label: 'Office',
            //         addressLine1: 'House No. 2',
            //         addressLine2: 'Road No. 2',
            //         longitude: 24.861330511134447,
            //         latitude: 67.02928348779203,
            //         landmark: 'Near to XYZ',
            //         city: 'Kathmandu',
            //         state: 'Bagmati',
            //         zipCode: '12345',
            //     },
            //     {
            //         label: 'Other',
            //         addressLine1: 'House No. 3',
            //         addressLine2: 'Road No. 3',
            //         longitude: 26.861330511134447,
            //         latitude: 67.02928348779203,
            //         landmark: 'Near to XYZ',
            //         city: 'Kathmandu',
            //         state: 'Bagmati',
            //         zipCode: '12345',
            //     },
            //     {
            //         label: 'Other',
            //         addressLine1: 'House No. 4',
            //         addressLine2: 'Road No. 4',
            //         longitude: 24.861330511134447,
            //         latitude: 61.02928348779203,
            //         landmark: 'Near to XYZ',
            //         city: 'Kathmandu',
            //         state: 'Bagmati',
            //         zipCode: '12345',
            //     },
            //     {
            //         label: 'Other',
            //         addressLine1: 'House No. 5',
            //         addressLine2: 'Road No. 5',
            //         longitude: 24.861330511134447,
            //         latitude: 66.02928348779203,
            //         landmark: 'Near to XYZ',
            //         city: 'Kathmandu',
            //         state: 'Bagmati',
            //         zipCode: '12345',
            //     },
            // ];
            res.status(200).send({ data: data, emergencyContacts: emergencyContacts });
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/get-available-drivers', verifyToken, async (req, res) => {
    try {
        // const ambulanceType = req.body.ambulanceType;
        const users = await User.find({ role: 'Driver', rideInProgress: false, availableForWork: true });
        // const users = await User.find({ role: 'Driver', availableForWork: true });
        res.status(200).send(users);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-ride-in-progress', async (req, res) => {
    try {
        const users = await User.find({ role: 'Driver', email: req.body.email });
        users.forEach(async (user) => {
            user.rideInProgress = false;
            await user.save();
        });
        res.status(200).send('Ride in progress set to false for all drivers');
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-ride-in-progress1', async (req, res) => {
    try {
        const users = await User.find({ role: 'Driver' });
        users.forEach(async (user) => {
            user.rideInProgress = false;
            await user.save();
        });
        res.status(200).send('Ride in progress set to false for all drivers');
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/get-emergency-contacts', verifyToken, async (req, res) => {
    try {
        const {
            email
        } = req.body;
        const user = await User.findOne({ email: email });
        if (!user) {
            res.status(404).json({ error: 'User not found' });
        } else {
            const emergencyContacts = await EmergencyContact.find({
                $or: [
                    { user1: user._id },
                    { user2: user._id },
                ],
            }).populate('user1').populate('user2');
            res.status(200).send(emergencyContacts);
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/delete-emergency-contact', verifyToken, async (req, res) => {
    try {
        const emergencyContact = await EmergencyContact.findById(req.body._id);
        await emergencyContact.remove();
        res.status(200).send('Emergency contact deleted');
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-current-location', verifyToken, async (req, res) => {
    try {
        const {
            email,
            lat,
            lng,
        } = req.body;
        const user = await User.findOne({ email: email });
        user.currentLocation = {
            latitude: lat,
            longitude: lng,
        };
        await user.save();
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
});

router.post('/set-ride-status', verifyToken, async (req, res) => {
    try {
        const {
            driverEmail,
        } = req.body;
        const user = await User.findOne({ email: driverEmail });
        user.rideInProgress = true;
        await user.save();
        res.status(200).send(user);
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error });
    }
})

router.post('/add', async (req, res) => {
    try {
        const newUser = new User({
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            email: req.body.email,
            contactNumber: req.body.contactNumber,
            role: req.body.role,
            isActive: req.body.isActive,
        });
        await newUser.save();
        res.status(200).json({ data: newUser });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

module.exports = router;