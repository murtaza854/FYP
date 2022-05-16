const mongoose = require('mongoose');

const OrganizationSchema = new mongoose.Schema({
    name: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

OrganizationSchema.virtual('ambulances', {
    ref: 'ambulances',
    localField: '_id',
    foreignField: 'organization',
    justOne: false,
});

OrganizationSchema.set('toObject', { virtuals: true });
OrganizationSchema.set('toJSON', { virtuals: true });

const Organization = mongoose.model('organizations', OrganizationSchema);

module.exports = Organization;