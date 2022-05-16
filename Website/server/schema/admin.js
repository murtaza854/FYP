const mongoose = require('mongoose');

const AdminSchema = new mongoose.Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, required: true },
    firebaseUID: { type: String, required: false },
    accountSetup: { type: Boolean, required: true, default: false },
});

const User = mongoose.model('admins', AdminSchema);

module.exports = User;