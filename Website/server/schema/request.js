const mongoose = require('mongoose');

const requestSchema = new mongoose.Schema({
    sender: { type: String, required: true },
    senderFirstName: { type: String, required: true },
    senderName: { type: String, required: true },
    receiver: { type: String, required: true },
    receiverFirstName: { type: String, required: true },
    receiverName: { type: String, required: true },
    relationship: { type: String, required: true },
    status: { type: Boolean, required: true, default: false },
    seenAfterAcceptanceFrom: { type: Boolean, required: true, default: false },
    createdAt: { type: Date, default: Date.now },
});

const Request = mongoose.model('requests', requestSchema);

module.exports = Request;