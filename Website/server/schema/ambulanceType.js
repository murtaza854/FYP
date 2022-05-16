const mongoose = require('mongoose');

const AmbulanceTypeSchema = new mongoose.Schema({
    name: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const AmbulanceType = mongoose.model('ambulanceTypes', AmbulanceTypeSchema);

module.exports = AmbulanceType;