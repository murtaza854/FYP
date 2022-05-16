import React, { useContext, useState } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Input from '@mui/material/Input';
import InputLabel from '@mui/material/InputLabel';
import InputAdornment from '@mui/material/InputAdornment';
import FormControl from '@mui/material/FormControl';
import IconButton from '@mui/material/IconButton';
import Button from '@mui/material/Button';
import { Col, Container, Row, Form } from 'react-bootstrap';
import { useHistory } from 'react-router';
import UserContext from '../../contexts/userContext';
import api from '../../api';
import EmailIcon from '@mui/icons-material/Email';
import LockIcon from '@mui/icons-material/Lock';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import './Login.scss';

function Login(props) {
    const [email, setEmail] = useState({ name: '', errorText: '', error: false });
    const [password, setPassword] = useState({ name: '', errorText: '', error: false, showPassword: false });

    // const [disable, setDisable] = useState(false);

    const history = useHistory();

    const user = useContext(UserContext);

    const handleClickShowPassword = _ => {
        setPassword(prevState => ({ ...prevState, showPassword: !password.showPassword }));
    }
    const handleMouseDownPassword = event => {
        event.preventDefault();
    }
    const changePassword = event => {
        setPassword(prevState => ({ ...prevState, name: event.target.value }));
    }

    const changeEmail = event => {
        setEmail(prevState => ({ ...prevState, name: event.target.value }));
    }

    const handleSubmit = async e => {
        e.preventDefault();
        // setDisable(true);
        try {
            const response = await fetch(`${api}/user/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'include',
                withCredentials: true,
                body: JSON.stringify({ email, password })
            });
            const content = await response.json();
            console.log(content);
            if (content.error === "Email not verified") {
                history.push("/__/auth/action?mode=emailNotVerified");
            } else if (content.error) {
                setEmail(prevState => ({ ...prevState, name: '', errorText: 'Invalid Credentials!', error: true }));
                setPassword(prevState => ({ ...prevState, name: '', errorText: 'Invalid Credentials!', error: true, showPassword: false }));
                // setDisable(false);
            } else {
                const { displayName, email, emailVerified, admin } = content.data;
                user.setUserState({ displayName, email, emailVerified, admin });
            }
        } catch (error) {
            // setDisable(false);
        }
    }

    return (
        <Container className="admin-login-container" fluid>
            <Row>
                <Col className="admin-login-card" md={4}>
                    <Card className="admin-login-base">
                        <h1>Admin Login</h1>
                        <CardContent className="admin-card-formcontrol">
                            <Form onSubmit={handleSubmit} autoComplete="off" noValidate>
                                <FormControl className="admin-card-formcontrol">
                                    <InputLabel htmlFor="email-admin">Email</InputLabel>
                                    <Input
                                        autoComplete="off"
                                        autoFocus
                                        type="email"
                                        value={email.name}
                                        onChange={changeEmail}
                                        id="email-admin"
                                        startAdornment={
                                            <InputAdornment position="start">
                                                <EmailIcon />
                                            </InputAdornment>
                                        }
                                    />
                                </FormControl>
                                <FormControl className="admin-card-formcontrol">
                                    <InputLabel htmlFor="standard-adornment-password">Password</InputLabel>
                                    <Input
                                        autoComplete="off"
                                        id="standard-adornment-password"
                                        type={password.showPassword ? 'text' : 'password'}
                                        value={password.name}
                                        onChange={changePassword}
                                        startAdornment={
                                            <InputAdornment position="start">
                                                <LockIcon />
                                            </InputAdornment>
                                        }
                                        endAdornment={
                                            <InputAdornment position="end">
                                                <IconButton
                                                    aria-label="toggle password visibility"
                                                    onClick={handleClickShowPassword}
                                                    onMouseDown={handleMouseDownPassword}
                                                >
                                                    {password.showPassword ? <VisibilityIcon /> : <VisibilityOffIcon />}
                                                </IconButton>
                                            </InputAdornment>
                                        }
                                    />
                                </FormControl>
                                <input
                                    type="text"
                                    autoComplete="on"
                                    value=""
                                    style={{ display: 'none' }}
                                    readOnly={true}
                                />
                                <Button type="submit" variant="contained" color="primary" className="admin-login-button">
                                    Login
                                </Button>
                            </Form>
                        </CardContent>
                    </Card>
                </Col>
            </Row>
        </Container>
    );
}

export default Login;