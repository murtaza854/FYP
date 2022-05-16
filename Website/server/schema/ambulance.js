const mongoose = require('mongoose');

const AmbulanceSchema = new mongoose.Schema({
    numberPlate: { type: String, required: true },
    ambulanceType: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

AmbulanceSchema.virtual('driver', {
    ref: 'users',
    localField: '_id',
    foreignField: 'ambulances',
    justOne: true,
});

AmbulanceSchema.set('toObject', { virtuals: true });
AmbulanceSchema.set('toJSON', { virtuals: true });

const Ambulance = mongoose.model('ambulances', AmbulanceSchema);

module.exports = Ambulance;