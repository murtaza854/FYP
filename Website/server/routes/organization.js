const router = require('express').Router();
const Organization = require('../schema').organization;

router.get('/getAllOrganizations', async (req, res) => {
    try {
        const organizations = await Organization.find().populate({
            path: 'ambulances',
        })
        console.log('organizations');
        res.status(200).json({ data: organizations });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/getById', async (req, res) => {
    try {
        const organization = await Organization.findById(req.body.id);
        res.status(200).json({ data: organization });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/add', async (req, res) => {
    try {
        const organization = new Organization(req.body);
        await organization.save();
        res.status(200).json({ data: organization });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/add-organization', async (req, res) => {
    try {
        const organization = new Organization({
            name: 'Organization A'
        });
        await organization.save();
        res.status(200).json({ data: organization });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

router.post('/edit', async (req, res) => {
    try {
        const organization = await Organization.findById(req.body.id);
        organization.name = req.body.name;
        await organization.save();
        res.status(200).json({ data: organization });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err });
    }
});

module.exports = router;