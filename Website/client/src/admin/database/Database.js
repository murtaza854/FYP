import React from 'react';
import { UserForm, UserTable } from './user';
import { OrganizationForm, OrganizationTable } from './organization';
import { AmbulanceTypeForm, AmbulanceTypeTable } from './ambulanceType';
import { AmbulanceTable } from './ambulance';
// import { FirstAidTipForm, FirstAidTipTable } from './firstAidTip';
import { CreateUserData } from './user/userTable/CreateUserData';
import { CreateOrganizationData } from './organization/organizationTable/CreateOrganizationData';
import { CreateAmbulanceTypeData } from './ambulanceType/ambulanceTypeTable/CreateAmbulanceTypeData';
import { CreateAmbulanceData } from './ambulance/ambulanceTable/CreateAmbulanceData';
// import { CreateFirstAidTipData } from './firstAidTip/firstAidTipTable/CreateFirstAidTipData';
import {
    Switch,
    Route,
    useHistory
} from "react-router-dom";
import api from '../../api';
import Dash from './dash/Dash';

function Database(props) {
    const [rows, setRows] = React.useState([]);
    const [filteredRows, setFilteredRows] = React.useState([]);
    const [historyChanged, setHistoryChanged] = React.useState(false);

    let history = useHistory();

    const {
        setLinkDisableObject
    } = props;

    const urlPath = window.location.pathname;
    let fetchUrl = '';
    let chosenFunction = function (params) { };
    if (urlPath === '/admin/user' || urlPath === '/admin/user/add') {
        fetchUrl = 'user/getAllUsers';
        chosenFunction = CreateUserData;
    } else if (urlPath === '/admin/admin-members' || urlPath === '/admin/admin-members/add') {
        fetchUrl = 'admin/getAllAdmins';
        chosenFunction = CreateUserData;
    } else if (urlPath === '/admin/organization' || urlPath === '/admin/organization/add' || urlPath === '/admin/organization/edit') {
        fetchUrl = 'organization/getAllOrganizations';
        chosenFunction = CreateOrganizationData;
    } else if (urlPath === '/admin/ambulance-type' || urlPath === '/admin/ambulance-type/add' || urlPath === '/admin/ambulance-type/edit') {
        fetchUrl = 'ambulanceType/getAllAmbulanceTypes';
        chosenFunction = CreateAmbulanceTypeData;
    } else if (urlPath === '/admin/ambulance') {
        fetchUrl = 'ambulance/getAllAmbulances';
        chosenFunction = CreateAmbulanceData;
    } else if (urlPath === '/admin/first-aid-tip' || urlPath === '/admin/first-aid-tip/add' || urlPath === '/admin/first-aid-tip/edit') {
        // fetchUrl = 'firstAidTip/getAllFirstAidTips';
        // chosenFunction = CreateFirstAidTipData;
    }

    history.listen((location, action) => {
        setRows([]);
        setFilteredRows([]);
        setHistoryChanged(!historyChanged);
    })


    React.useEffect(() => {
        if (urlPath === '/admin/user') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': false,
                'user': true,
                'organization': false,
                'ambulanceType': false,
                'ambulance': false,
                'firstAidTip': false
            });
        } else if (urlPath === '/admin/admin-members') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': true,
                'user': false,
                'organization': false,
                'ambulanceType': false,
                'ambulance': false,
                'firstAidTip': false
            });
        } else if (urlPath === '/admin/organization') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': false,
                'user': false,
                'organization': true,
                'ambulanceType': false,
                'ambulance': false,
                'firstAidTip': false
            });
        } else if (urlPath === '/admin/ambulance-type') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': false,
                'user': false,
                'organization': false,
                'ambulanceType': true,
                'ambulance': false,
                'firstAidTip': false
            });
        } else if (urlPath === '/admin/ambulance') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': false,
                'user': false,
                'organization': false,
                'ambulanceType': false,
                'ambulance': true,
                'firstAidTip': false
            });
        } else if (urlPath === '/admin/first-aid-tip') {
            setLinkDisableObject({
                'dashboard': false,
                'admin': false,
                'user': false,
                'organization': false,
                'ambulanceType': false,
                'ambulance': false,
                'firstAidTip': true
            });
        } else {
            setLinkDisableObject({
                'dashboard': true,
                'admin': false,
                'user': false,
                'organization': false,
                'ambulanceType': false,
                'ambulance': false,
                'firstAidTip': false
            });
        }
        if (fetchUrl !== '') {
            fetch(`${api}/${fetchUrl}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(res => res.json())
                .then(data => {
                    const rows = data.data.map(obj => {
                        return chosenFunction(obj);
                    });
                    setRows(rows);
                    setFilteredRows(rows);
                });
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [fetchUrl, urlPath, historyChanged]);

    return (
        <Switch>
            <Route path="/admin/organization/edit/:id">
                <OrganizationForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route>
            <Route path="/admin/ambulance-type/edit/:id">
                <AmbulanceTypeForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route>
            {/* <Route path="/admin/first-aid-tip/edit/:id">
                <FirstAidTipForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route> */}
            <Route path="/admin/organization/add">
                <OrganizationForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route>
            <Route path="/admin/ambulance-type/add">
                <AmbulanceTypeForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route>
            <Route path="/admin/user/add">
                <UserForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route>
            {/* <Route path="/admin/first-aid-tip/add">
                <FirstAidTipForm
                    rows={rows}
                    setRows={setRows}
                    setFilteredRows={setFilteredRows}
                />
            </Route> */}
            <Route path="/admin/user">
                <UserTable
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="name"
                    searchField="name"
                />
            </Route>
            <Route path="/admin/organization">
                <OrganizationTable
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="name"
                    searchField="name"
                />
            </Route>
            <Route path="/admin/ambulance-type">
                <AmbulanceTypeTable
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="name"
                    searchField="name"
                />
            </Route>
            <Route path="/admin/ambulance">
                <AmbulanceTable
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="driver"
                    searchField="driver"
                />
            </Route>
            <Route path="/admin">
                <Dash
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="driver"
                    searchField="driver"
                />
            </Route>
            {/* <Route path="/admin/first-aid-tip">
                <FirstAidTipTable
                    rows={rows}
                    filteredRows={filteredRows}
                    setFilteredRows={setFilteredRows}
                    tableOrder="title"
                    searchField="title"
                />
            </Route> */}
        </Switch>
    );
}

export default Database;