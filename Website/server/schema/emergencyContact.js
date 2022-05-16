const mongoose = require('mongoose');

const EmergenceyContactSchema = new mongoose.Schema({
    user1: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    user2: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    user1RelationToUser2: { type: String, required: true },
    user2RelationToUser1: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const EmergencyContact = mongoose.model('emergencyContacts', EmergenceyContactSchema);

module.exports = EmergencyContact;