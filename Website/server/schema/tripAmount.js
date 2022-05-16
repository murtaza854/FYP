const mongoose = require('mongoose');

const tripAmountSchema = new mongoose.Schema({
    month: { type: String, required: true },
    year: { type: String, required: true },
    count: { type: Number, required: true }
});

const TripAmount = mongoose.model('tripAmounts', tripAmountSchema);

module.exports = TripAmount;
