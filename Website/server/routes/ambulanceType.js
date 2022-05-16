const router = require('express').Router();
const AmbulanceType = require('../schema').ambulanceType;

router.get('/getAllAmbulanceTypes', async (req, res) => {
    try {
        const ambulanceTypes = await AmbulanceType.find();
        res.status(200).json({ data: ambulanceTypes });
    } catch (e) {
        res.status(500).send(null);
    }
});

router.post('/getById', async (req, res) => {
    try {
        const ambulanceType = await AmbulanceType.findById(req.body.id);
        res.status(200).json({ data: ambulanceType });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/add', async (req, res) => {
    try {
        const ambulanceType = new AmbulanceType(req.body);
        await ambulanceType.save();
        res.status(200).json({ data: ambulanceType });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/edit', async (req, res) => {
    try {
        const ambulanceType = await AmbulanceType.findById(req.body.id);
        ambulanceType.name = req.body.name;
        await ambulanceType.save();
        res.status(200).json({ data: ambulanceType });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

module.exports = router;
