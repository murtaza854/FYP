const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema({
    responseTime: { type: Number, required: false },
    commuteTime: { type: Number, required: false },
    distanceTravelledToPatient: { type: Number, required: false },
    distanceTravelledToDestination: { type: Number, required: false },
    startLocationFromAcceptance: {
        name: { type: String, required: true },
        latitude: { type: Number, required: true },
        longitude: { type: Number, required: true }
    },
    startLocation: {
        name: { type: String, required: false },
        latitude: { type: Number, required: false },
        longitude: { type: Number, required: false }
    },
    endLocation: {
        name: { type: String, required: false },
        latitude: { type: Number, required: false },
        longitude: { type: Number, required: false }
    },
    startTimeFromAcceptance: { type: Date, required: true, default: Date.now },
    startTime: { type: Date, required: false },
    endTime: { type: Date, required: false },
    patient: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    ambulance: { type: mongoose.Schema.Types.ObjectId, ref: 'ambulances', required: true },
    status: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const Trip = mongoose.model('trips', tripSchema);

module.exports = Trip;