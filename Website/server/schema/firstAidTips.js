const mongoose = require('mongoose');

const FirstAidTipsSchema = new mongoose.Schema({
    title: { type: String, required: true },
    paragraphs: [
        { 
            description: { type: String, required: true },
        }
    ],
    active: { type: Boolean, required: true, default: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const FirstAidTips = mongoose.model('FirstAidTips', FirstAidTipsSchema);

module.exports = FirstAidTips;