const mongoose = require('mongoose');

const HospitalSchema = new mongoose.Schema({
    name: { type: String, required: true },
    city: { type: String, required: true },
    location: { type: String, required: true },
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const Hospitals = mongoose.model('hospitals', HospitalSchema);

module.exports = Hospitals;