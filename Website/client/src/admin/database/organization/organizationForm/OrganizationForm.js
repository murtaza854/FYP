import { FormControl, InputLabel, Typography, Input, FormHelperText, Button } from '@mui/material';
import React, { useState, useEffect } from 'react';
import { Col, Container, Form, Row } from 'react-bootstrap';
import { useParams } from 'react-router';
import api from '../../../../api';

function checkIfObjExistsByName(obj, name, id) {
    if (id) {
        return obj.find(o => o.name.toLowerCase() === name.toLowerCase() && o.id !== id);
    } else {
        return obj.find(o => o.name.toLowerCase() === name.toLowerCase());
    }
}

function OrganizationForm(props) {
    const {
        rows,
    } = props;
    const id = useParams().id || null;

    const [name, setName] = useState({ value: '', error: false, helperText: 'Enter a name Ex. Organization X' });

    const [disabled, setDisabled] = useState(true);

    useEffect(() => {
        (
            async () => {
                if (id) {
                    const response = await fetch(`${api}/organization/getById`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            id: id
                        })
                    });
                    const content = await response.json();
                    if (content.data) {
                        const { data } = content;
                        setName({ value: data.name, error: false, helperText: 'Enter a name Ex. Organization X' });
                    } else {
                        window.location.href = window.location.href.split('/admin')[0] + '/admin/organization';
                    }
                }
            })();
    }, [id]);

    useEffect(() => {
        let flag = true;
        if (name.error === true) flag = true;
        else if (name.value.length === 0) flag = true;
        else flag = false;
        setDisabled(flag);
    }, [name]);

    const handleNameChange = (event) => {
        if (event.target.value.length === 0) {
            setName({ value: event.target.value, error: true, helperText: 'Name is required!' });
        } else if (checkIfObjExistsByName(rows, event.target.value)) {
            setName({ value: event.target.value, error: true, helperText: 'Organization already exists!' });
        } else {
            setName({ value: event.target.value, error: false, helperText: 'Enter a name Ex. Organization X' });
        }
    }

    const handleSubmitAdd = async (event, mode) => {
        event.preventDefault();
        const response = await fetch(`${api}/organization/add`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                name: name.value,
            })
        });
        const content = await response.json();
        if (content.data) {
            if (mode === 'save') window.location.href = window.location.href.split('/admin')[0] + '/admin/organization';
            else window.location.href = window.location.href.split('/admin')[0] + '/admin/organization/add';
        } else {
            alert("Something went wrong.");
        }
    }

    const handleSubmitEdit = async (event, mode) => {
        event.preventDefault();
            const response = await fetch(`${api}/organization/edit`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    id: id,
                    name: name.value,
                })
            });
            const content = await response.json();
            if (content.data) {
                if (mode === 'save') window.location.href = window.location.href.split('/admin')[0] + '/admin/organization';
                else window.location.href = window.location.href.split('/admin')[0] + '/admin/organization/add';
            } else {
                alert("Something went wrong.");
            }
    }

    let onSubmit = handleSubmitAdd;
    if (id) onSubmit = handleSubmitEdit;

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
                        Organization
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
                            <InputLabel error={name.error} htmlFor="name">Name</InputLabel>
                            <Input id="name"
                                value={name.value}
                                onChange={handleNameChange}
                                onBlur={handleNameChange}
                                error={name.error}
                            />
                            <FormHelperText error={name.error}>{name.helperText}</FormHelperText>
                        </FormControl>
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

export default OrganizationForm;