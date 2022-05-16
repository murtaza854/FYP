import { FormControl, InputLabel, Typography, Input, FormControlLabel, Checkbox, FormHelperText, Button, Select, MenuItem } from '@mui/material';
import React, { useState, useEffect } from 'react';
import { Col, Container, Form, Row } from 'react-bootstrap';
import api from '../../../../api';

function checkIfObjExists(rows, string) {
    return rows.find(obj => obj.email.toLowerCase() === string.toLowerCase());
}

function UserForm(props) {
    const {
        rows,
    } = props;

    const [firstName, setFirstName] = useState({ value: '', error: false, helperText: 'Enter a first name Ex. John' });
    const [lastName, setLastName] = useState({ value: '', error: false, helperText: 'Enter a last name Ex. Doe' });
    const [email, setEmail] = useState({ value: '', error: false, helperText: 'Enter an email address Ex. john.doe@tezz.com' });
    const [contactNumber, setContactNumber] = useState({ value: '', error: false, helperText: 'Enter a contact number Ex. (0321) 1234567' });
    const [role, setRole] = useState({ value: 'Patient', error: false, helperText: 'Select a role' });

    const [checkboxes, setCheckboxes] = useState({
        isActive: true,
    });

    const [disabled, setDisabled] = useState(true);


    useEffect(() => {
        let flag = true;
        if (firstName.error === true) flag = true;
        else if (firstName.value.length === 0) flag = true;
        else if (lastName.error === true) flag = true;
        else if (lastName.value.length === 0) flag = true;
        else if (email.error === true) flag = true;
        else if (email.value.length === 0) flag = true;
        else if (contactNumber.error === true) flag = true;
        else if (contactNumber.value.length === 0) flag = true;
        else flag = false;
        setDisabled(flag);
    }, [firstName, lastName, email, contactNumber]);

    const handleFirstNameChange = (event) => {
        if (event.target.value.length === 0) {
            setFirstName({ value: event.target.value, error: true, helperText: 'First name is required!' });
        } else {
            setFirstName({ value: event.target.value, error: false, helperText: 'Enter a first name Ex. John' });
        }
    }

    const handleLastNameChange = (event) => {
        if (event.target.value.length === 0) {
            setLastName({ value: event.target.value, error: true, helperText: 'Last name is required!' });
        } else {
            setLastName({ value: event.target.value, error: false, helperText: 'Enter a last name Ex. Doe' });
        }
    }

    const handleEmailChange = (event) => {
        const mailformat = /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/;
        if (event.target.value.length === 0) {
            setEmail({ value: event.target.value, error: true, helperText: 'Email is required!' });
        } else if (!event.target.value.match(mailformat)) {
            setEmail({ value: event.target.value, error: true, helperText: 'Enter a valid email address!' });
        } else if (checkIfObjExists(rows, event.target.value)) {
            setEmail({ value: event.target.value, error: true, helperText: 'Email already exists!' });
        } else {
            setEmail({ value: event.target.value, error: false, helperText: 'Enter an email address Ex. john.doe@tezz.com' });
        }
    }

    function formatPhoneNumber(phoneNumberString) {
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
        if (cleaned.length !== 11) {
            return null;
        }
        var match = cleaned.match(/^(0|)?(\d{3})(\d{3})((\d{4}))$/);
        if (match) {
            return ['(', match[1], match[2], ') ', match[3], '', match[4]].join('');
        }
        return null;
    }

    const handleContactNumberChange = (event) => {
        const phoneNumber = formatPhoneNumber(event.target.value);
        if (phoneNumber) {
            setContactNumber({ value: phoneNumber, error: false, helperText: 'Enter a contact number Ex. (0321) 1234567' });
        } else {
            setContactNumber({ value: event.target.value, error: true, helperText: 'Enter a valid contact number!' });
        }
    }

    const handleRoleChange = (event) => {
        setRole({ value: event.target.value, error: false, helperText: 'Select a role' });
    }

    const handleActiveChange = (event) => {
        setCheckboxes({ ...checkboxes, isActive: !checkboxes.isActive });
    }

    const handleSubmitAdd = async (event, mode) => {
        event.preventDefault();
        const response = await fetch(`${api}/user/add`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                firstName: firstName.value,
                lastName: lastName.value,
                email: email.value,
                contactNumber: contactNumber.value,
                role: role.value,
                isActive: checkboxes.isActive,
            })
        });
        const content = await response.json();
        if (content.data) {
            if (mode === 'save') window.location.href = window.location.href.split('/admin')[0] + '/admin/user';
            else window.location.href = window.location.href.split('/admin')[0] + '/admin/user/add';
        } else {
            alert("Something went wrong.");
        }
    }

    let onSubmit = handleSubmitAdd;

    return (
        <Container fluid>
            <Row>
                <Col>
                    <Typography
                        sx={{ flex: '1 1 100%' }}
                        variant="h6"
                        id="tableTitle"
                        component="div"
                    >
                        User
                    </Typography>
                </Col>
            </Row>
            <Form onSubmit={e => onSubmit(e, 'save')}>
                <input
                    type="password"
                    autoComplete="on"
                    value=""
                    style={{ display: 'none' }}
                    readOnly={true}
                />
                <Row>
                    <Col md={6}>
                        <FormControl variant="standard" fullWidth>
                            <InputLabel error={firstName.error} htmlFor="firstName">First name</InputLabel>
                            <Input id="firstName"
                                value={firstName.value}
                                onChange={handleFirstNameChange}
                                onBlur={handleFirstNameChange}
                                error={firstName.error}
                            />
                            <FormHelperText error={firstName.error}>{firstName.helperText}</FormHelperText>
                        </FormControl>
                    </Col>
                    <Col md={6}>
                        <FormControl variant="standard" fullWidth>
                            <InputLabel error={lastName.error} htmlFor="lastName">Last name</InputLabel>
                            <Input id="lastName"
                                value={lastName.value}
                                onChange={handleLastNameChange}
                                onBlur={handleLastNameChange}
                                error={lastName.error}
                            />
                            <FormHelperText error={lastName.error}>{lastName.helperText}</FormHelperText>
                        </FormControl>
                    </Col>
                </Row>
                <div className="margin-global-top-1" />
                <Row>
                    <Col md={6}>
                        <FormControl variant="standard" fullWidth>
                            <InputLabel error={email.error} htmlFor="email">Email</InputLabel>
                            <Input id="email"
                                value={email.value}
                                onChange={handleEmailChange}
                                onBlur={handleEmailChange}
                                error={email.error}
                            />
                            <FormHelperText error={email.error}>{email.helperText}</FormHelperText>
                        </FormControl>
                    </Col>
                    <Col md={6}>
                        <FormControl variant="standard" fullWidth>
                            <InputLabel error={contactNumber.error} htmlFor="contactNumber">Contact number</InputLabel>
                            <Input id="contactNumber"
                                value={contactNumber.value}
                                onChange={handleContactNumberChange}
                                onBlur={handleContactNumberChange}
                                error={contactNumber.error}
                            />
                            <FormHelperText error={contactNumber.error}>{contactNumber.helperText}</FormHelperText>
                        </FormControl>
                    </Col>
                </Row>
                <div className="margin-global-top-1" />
                <Row>
                    <Col md={6}>
                        <FormControl variant="standard" fullWidth>
                            <InputLabel error={role.error} htmlFor="role">Role</InputLabel>
                            <Select
                                id="role"
                                value={role.value}
                                onChange={handleRoleChange}
                                error={role.error}
                            >
                            <MenuItem value={'Patient'}>Patient</MenuItem>
                                <MenuItem value={'Driver'}>Driver</MenuItem>
                            </Select>
                            <FormHelperText error={role.error}>{role.helperText}</FormHelperText>
                        </FormControl>
                    </Col>
                </Row>
                <div className="margin-global-top-1" />
                <Row>
                    <Col md={6}>
                        <FormControlLabel
                            control={<Checkbox
                                checked={checkboxes.isActive}
                                onChange={handleActiveChange}
                            />}
                            label="Active"
                        />
                    </Col>
                </Row>
                <div className="margin-global-top-1" />
                <Row>
                    <Col className="flex-display">
                        <Button disabled={disabled} type="submit" variant="contained" color="secondary">
                            Save
                        </Button>
                        <div className="margin-global-05" />
                        <Button onClick={e => onSubmit(e, 'addAnother')} disabled={disabled} type="button" variant="contained" color="secondary">
                            Save and Add Another
                        </Button>
                    </Col>
                </Row>
            </Form>
        </Container>
    );
}

export default UserForm;