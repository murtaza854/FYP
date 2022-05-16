import React, { useContext, useEffect, useState } from 'react';
import { Login, AdminLayout } from '../admin';
import { ThemeProvider } from '@mui/styles';
import { createTheme } from '@mui/material/styles';
import './Admin.scss';
import UserContext from '../contexts/userContext';


function Admin(props) {
    const [darkState, setDarkState] = useState(false);
    const [loading, setLoading] = useState(true);
    const user = useContext(UserContext);
    const [adminState, setAdminState] = useState(null);
    
    const darkTheme = createTheme({
        palette: {
            type: 'dark',
            primary: {
                main: '#90bede',
                contrastText: 'rgba(255,255,255,0.87)',
            },
            secondary: {
                main: '#f7d43e',
            },
            background: {
                //   default: '#ffffff',
                //   paper: '#ededed',
            },
            error: {
                main: '#c31200',
            },
        },
        typography: {
            fontFamily: 'Raleway',
        },
    });
    const lightTheme = createTheme({
        palette: {
            type: 'light',
            primary: {
                main: '#90bede',
                contrastText: 'rgba(255,255,255,0.87)',
            },
            secondary: {
                main: '#f7d43e',
            },
            background: {
                //   default: '#ffffff',
                //   paper: '#ededed',
            },
            error: {
                main: '#c31200',
            },
        },
        typography: {
            fontFamily: 'Raleway',
        },
    });
    const currentTheme = darkState ? darkTheme : lightTheme;

    useEffect(() => {
        (
            async () => {
                try {
                    // const response = await fetch(`${api}/logged-in-admin`, {
                    //     method: 'GET',
                    //     headers: {
                    //         'Content-Type': 'application/json',
                    //     },
                    //     credentials: 'include',
                    //     withCredentials: true,
                    // });
                    // const content = await response.json();
                    // const user = content.data;
                    // const { displayName, email, emailVerified, admin } = user;
                    // setAdminState({ displayName, email, emailVerified, admin });
                    setLoading(false);
                } catch (error) {
                    setAdminState(null);
                    setLoading(false);
                }
            })();
    }, []);

    if (loading) return <div></div>;

    return (
        <UserContext.Provider value={{ adminState: adminState, setAdminState: setAdminState }}>
            <ThemeProvider theme={currentTheme}>
                {/* <Login setToken={setToken} title="Mzushi: Admin Login" /> */}
                {adminState ? (
                    <Login user={user} title="The Sew Story: Admin Login" />
                ) : (
                    <AdminLayout user={user} darkState={darkState} setDarkState={setDarkState} title="Mzushi: Dashboard" />
                )}
            </ThemeProvider>
        </UserContext.Provider >
    );
}

export default Admin;