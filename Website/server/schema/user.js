const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, required: true },
    contactNumber: { type: String },
    firebaseUID: { type: String, required: false },
    passwordCreated: { type: Boolean, default: true },
    tempPassword: { type: String, required: false },
    role: { type: String, required: true },
    accountSetup: { type: Boolean, required: true, default: false },
    isActive: { type: Boolean, required: true, default: true },
    medicalCard: {
        gender: { type: String },
        dateOfBirth: { type: Date },
        bloodGroup: { type: String },
        height: { type: Number },
        weight: { type: Number },
        primaryMedicalConditions: [{ type: String }],
        allergies: [{ type: String }],
        vaccinations: [{ type: String }],
        familyHistory: { type: String },
        notes: { type: String },
    },
    trips: [{ type: mongoose.Schema.Types.ObjectId, ref: 'trips', required: true }],
    ambulances: [{ type: mongoose.Schema.Types.ObjectId, ref: 'ambulances' }],
    ambulanceType: { type: String },
    organization: { type: mongoose.Schema.Types.ObjectId, ref: 'organizations' },
    addresses: [{
        label: { type: String },
        addressLine1: { type: String },
        addressLine2: { type: String },
        longitude: { type: Number },
        latitude: { type: Number },
        landmark: { type: String },
    }],
    rideInProgress: { type: Boolean, required: true, default: false },
    availableForWork: { type: Boolean, required: true, default: false },
    currentLocation: {
        latitude: { type: Number },
        longitude: { type: Number },
    },
    numberOfAcceptedTrips: [{
        month: { type: String, required: true },
        year: { type: String, required: true },
        count: { type: Number, required: true }
    }],
    numberOfRejectedTrips: [{
        month: { type: String, required: true },
        year: { type: String, required: true },
        count: { type: Number, required: true }
    }],
    numberOfCancelledTrips: [{
        month: { type: String, required: true },
        year: { type: String, required: true },
        count: { type: Number, required: true }
    }],
    numberOfCompletedTrips: [{
        month: { type: String, required: true },
        year: { type: String, required: true },
        count: { type: Number, required: true }
    }],
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const User = mongoose.model('users', UserSchema);

module.exports = User;