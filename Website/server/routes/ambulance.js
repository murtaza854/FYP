const router = require('express').Router();
const Ambulance = require('../schema').ambulance;

router.get('/getAllAmbulances', async (req, res) => {
    try {
        const ambulances = await Ambulance.find().populate({
            path: 'organization',
        });
        res.status(200).json({ data: ambulances });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/add-ambulance', async (req, res) => {
    try {
        const ambulance = await new Ambulance({
            numberPlate: 'AAA111',
            ambulanceType: '2 Paramedics',
            organization: 1,
        });
    } catch (error) {
        
    }
});

module.exports = router;