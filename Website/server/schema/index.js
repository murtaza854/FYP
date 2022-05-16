const admin = require('./admin');
const user = require('./user');
const ambulance = require('./ambulance');
const ambulanceType = require('./ambulanceType');
const FirstAidTips = require('./firstAidTips');
const organization = require('./organization');
const trip = require('./trip');
const tripAmount = require('./tripAmount');
const request = require('./request');
const emergencyContact = require('./emergencyContact');

module.exports = {
    admin,
    user,
    ambulance,
    ambulanceType,
    FirstAidTips,
    organization,
    trip,
    tripAmount,
    request,
    emergencyContact
};