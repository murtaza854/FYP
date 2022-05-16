import * as React from 'react';
import { useTheme } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import List from '@mui/material/List';
import CssBaseline from '@mui/material/CssBaseline';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import { AppBar, Drawer, DrawerHeader } from './layoutHelpers';
import Database from '../database/Database';
// import { Link } from 'react-router-dom';
// import DashboardIcon from '@mui/icons-material/Dashboard';
import GroupIcon from '@mui/icons-material/Group';
import DashboardIcon from '@mui/icons-material/Dashboard';
import ManageAccountsIcon from '@mui/icons-material/ManageAccounts';
import BusinessIcon from '@mui/icons-material/Business';
import MedicalServicesIcon from '@mui/icons-material/MedicalServices';
import LocalHospitalIcon from '@mui/icons-material/LocalHospital';

export default function AdminLayout() {
    const theme = useTheme();
    const [open, setOpen] = React.useState(false);
    const [linkDisableObject, setLinkDisableObject] = React.useState({
        'dashboard': false,
        'admin': false,
        'user': false,
        'organization': false,
        'ambulanceType': false,
        'ambulance': false,
        'firstAidTip': false,
    });

    const handleDrawerOpen = () => {
        setOpen(true);
    };

    const handleDrawerClose = () => {
        setOpen(false);
    };
    const handleLinkDisable = (e, link) => {
        if (linkDisableObject[link]) {
            e.preventDefault();
            return;
        }
    }

    return (
        <Box sx={{ display: 'flex', overflowX: 'auto' }}>
            <CssBaseline />
            <AppBar position="fixed" open={open}>
                <Toolbar>
                    <IconButton
                        color="inherit"
                        aria-label="open drawer"
                        onClick={handleDrawerOpen}
                        edge="start"
                        sx={{
                            marginRight: '36px',
                            ...(open && { display: 'none' }),
                        }}
                    >
                        <MenuIcon />
                    </IconButton>
                    <Typography variant="h6" noWrap component="div">
                        Tezz Admin
                    </Typography>
                </Toolbar>
            </AppBar>
            <Drawer variant="permanent" open={open}>
                <DrawerHeader>
                    <IconButton onClick={handleDrawerClose}>
                        {theme.direction === 'rtl' ? <ChevronRightIcon /> : <ChevronLeftIcon />}
                    </IconButton>
                </DrawerHeader>
                <Divider />
                <List>
                    <a onClick={e => handleLinkDisable(e, 'dashboard')} style={{ color: 'black', textDecoration: 'none' }} href="/admin">
                        <ListItem disabled={linkDisableObject.dashboard} button>
                            <ListItemIcon>
                                <DashboardIcon />
                            </ListItemIcon>
                            <ListItemText primary="Dashboard" />
                        </ListItem>
                    </a>
                </List>
                <Divider />
                <List>
                    <a onClick={e => handleLinkDisable(e, 'admin')} style={{ color: 'black', textDecoration: 'none' }} href="/admin/admin-members">
                        <ListItem disabled={linkDisableObject.admin} button>
                            <ListItemIcon>
                                <ManageAccountsIcon />
                            </ListItemIcon>
                            <ListItemText primary="Admin" />
                        </ListItem>
                    </a>
                    <a onClick={e => handleLinkDisable(e, 'user')} style={{ color: 'black', textDecoration: 'none' }} href="/admin/user">
                        <ListItem disabled={linkDisableObject.user} button>
                            <ListItemIcon>
                                <GroupIcon />
                            </ListItemIcon>
                            <ListItemText primary="Users" />
                        </ListItem>
                    </a>
                </List>
                <Divider />
                <List>
                    <a onClick={e => handleLinkDisable(e, 'organization')} style={{ color: 'black', textDecoration: 'none' }} href="/admin/organization">
                        <ListItem disabled={linkDisableObject.organization} button>
                            <ListItemIcon>
                                <BusinessIcon />
                            </ListItemIcon>
                            <ListItemText primary="Organizations" />
                        </ListItem>
                    </a>
                    <a onClick={e => handleLinkDisable(e, 'ambulanceType')} style={{ color: 'black', textDecoration: 'none' }} href="/admin/ambulance-type">
                        <ListItem disabled={linkDisableObject.ambulanceType} button>
                            <ListItemIcon>
                                <LocalHospitalIcon />
                            </ListItemIcon>
                            <ListItemText primary="Ambulance Types" />
                        </ListItem>
                    </a>
                    <a onClick={e => handleLinkDisable(e, 'ambulance')} style={{ color: 'black', textDecoration: 'none' }} href="/admin/ambulance">
                        <ListItem disabled={linkDisableObject.ambulance} button>
                            <ListItemIcon>
                                <MedicalServicesIcon />
                            </ListItemIcon>
                            <ListItemText primary="Ambulances" />
                        </ListItem>
                    </a>
                    {/* <Link onClick={e => handleLinkDisable(e, 'firstAidTip')} style={{ color: 'black', textDecoration: 'none' }} to="/admin/first-aid-tip">
                        <ListItem disabled={linkDisableObject.firstAidTip} button>
                            <ListItemIcon>
                                <MedicalServicesIcon />
                            </ListItemIcon>
                            <ListItemText primary="First aid tips" />
                        </ListItem>
                    </Link> */}
                </List>
            </Drawer>
            <Box component="main" sx={{ flexGrow: 1, p: 3 }}>
                <div className="margin-global-top-6" />
                <Database
                    linkDisableObject={linkDisableObject}
                    setLinkDisableObject={setLinkDisableObject}
                />
            </Box>
        </Box>
    );
}