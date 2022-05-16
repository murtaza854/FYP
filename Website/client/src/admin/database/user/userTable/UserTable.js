import * as React from 'react';
import Box from '@mui/material/Box';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TablePagination from '@mui/material/TablePagination';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Checkbox from '@mui/material/Checkbox';
import { TableToolbar } from "../tableToolbar/TableToolbar";
import { TableHead } from '../tableHead/TableHead';
import { TableFooter, TableHead as MuiHead } from "@mui/material";
import { stableSort } from '../../stabalizedSort';
import { getComparator } from '../../comparator';
import CheckIcon from '@mui/icons-material/Check';
import CloseIcon from '@mui/icons-material/Close';
import Collapse from '@mui/material/Collapse';
// import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';

// import { Col, Row } from 'react-bootstrap';
// import { ImageList, ImageListItem } from '@mui/material';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    BarElement,
    Title,
    Tooltip,
    Legend,
} from 'chart.js';

import { Line, Bar } from "react-chartjs-2";
import { Col, Container, Row } from 'react-bootstrap';
import { Typography } from '@mui/material';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    BarElement,
    Title,
    Tooltip,
    Legend,
);

const convertDateTime = (dateTime) => {
    const date = new Date(dateTime);
    return `${date.toLocaleDateString()}, ${date.toLocaleTimeString()}`;
}


export default function UserTable(props) {

    const lineChartDataResponseTime = {
        dataLine: {
            labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"],
            datasets: [
            ]
        }
    };

    const optionsResponseTime = {
        responsive: true,
        plugins: {
            legend: {
                display: false,
                position: 'bottom',
            },
            title: {
                display: true,
                text: 'Average Response Time (in minutes)',
            },
            scales: {
                x: {
                    display: true,
                    scaleLabel: 'Time'
                    // scaleLabel: {
                    //     display: true,
                    //     labelString: 'Time'
                    // }
                },
                y: {
                    display: true,
                    scaleLabel: 'Response Time (in minutes)'
                    // scaleLabel: {
                    //     display: true,
                    //     labelString: 'Response Time (in minutes)'
                    // }
                },
            },
        },
    };

    const lineChartDataCommuteTime = {
        dataLine: {
            labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"],
            datasets: [
            ]
        }
    };

    const optionsCommuteTime = {
        responsive: true,
        plugins: {
            legend: {
                display: false,
                position: 'bottom',
            },
            title: {
                display: true,
                text: 'Average Commute Time (in minutes)',
            },
            scales: {
                yAxes: [
                    {
                        ticks: {
                            beginAtZero: true,
                            max: 100,
                            min: 0,
                            stepSize: 10,
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Time (minutes)',
                        },
                    },
                ],
                xAxes: [
                    {
                        scaleLabel: {
                            display: true,
                            labelString: 'Time (hours)',
                        },
                    },
                ],
            },
        },
    };

    const labelsBarChart = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    const dataBarChart = {
        labels: labelsBarChart,
        datasets: [
            {
                label: 'Accepted Trips',
                data: [65, 59, 80, 81, 56, 55, 40, 65, 59, 80, 81, 56],
                backgroundColor: 'rgba(255, 134,159,0.4)',
            },
            {
                label: 'Rejected Trips',
                data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                backgroundColor: 'rgba(255, 218, 128,0.4)',
            },
            {
                label: 'Cancelled Trips',
                data: [65, 59, 80, 81, 56, 55, 40, 65, 59, 80, 81, 56],
                backgroundColor: 'rgba(170, 128, 252,0.4)',
            },
            {
                label: 'Completed Trips',
                data: [12, 19, 3, 5, 2, 3, 12, 19, 3, 5, 2, 3],
                backgroundColor: 'rgba(53, 162, 235, 0.5)',
            },
        ],
    };

    const optionsBarChart = {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom',
            },
            title: {
                display: true,
                text: 'Number of Trips',
            },
        },
    };

    const {
        rows,
        filteredRows,
        setFilteredRows,
        tableOrder,
        searchField
    } = props;

    const [order, setOrder] = React.useState('asc');
    const [orderBy, setOrderBy] = React.useState(tableOrder);
    const [selected, setSelected] = React.useState([]);
    const [page, setPage] = React.useState(0);
    const [rowsPerPage, setRowsPerPage] = React.useState(5);
    const [searchText, setSearchText] = React.useState('');
    const [open, setOpen] = React.useState([].fill(false, 0, rows.length));

    React.useEffect(() => {
        if (rows.length > 0) {
            setFilteredRows(rows.filter(row => {
                return row[searchField].toLowerCase().includes(searchText.toLowerCase());
            }));
        }
    }, [searchText, rows, setFilteredRows, searchField]);

    const handleSearch = event => {
        setSearchText(event.target.value);
    };

    const handleRequestSort = (event, property) => {
        const isAsc = orderBy === property && order === 'asc';
        setOrder(isAsc ? 'desc' : 'asc');
        setOrderBy(property);
    };

    const handleSelectAllClick = (event) => {
        if (event.target.checked) {
            const newSelecteds = filteredRows.map((n) => n.id);
            setSelected(newSelecteds);
            return;
        }
        setSelected([]);
    };

    const handleClick = (event, id) => {
        const selectedIndex = selected.indexOf(id);
        let newSelected = [];

        if (selectedIndex === -1) {
            newSelected = newSelected.concat(selected, id);
        } else if (selectedIndex === 0) {
            newSelected = newSelected.concat(selected.slice(1));
        } else if (selectedIndex === selected.length - 1) {
            newSelected = newSelected.concat(selected.slice(0, -1));
        } else if (selectedIndex > 0) {
            newSelected = newSelected.concat(
                selected.slice(0, selectedIndex),
                selected.slice(selectedIndex + 1),
            );
        }

        setSelected(newSelected);
    };

    const handleChangePage = (event, newPage) => {
        setPage(newPage);
    };

    const handleChangeRowsPerPage = (event) => {
        setRowsPerPage(parseInt(event.target.value, 10));
        setPage(0);
    };

    const isSelected = (id) => selected.indexOf(id) !== -1;

    // Avoid a layout jump when reaching the last page with empty rows.
    const emptyRows =
        page > 0 ? Math.max(0, (1 + page) * rowsPerPage - filteredRows.length) : 0;

    return (
        <Box sx={{ width: '100%' }}>
            <Paper sx={{ width: '100%', mb: 2 }}>
                <TableToolbar selected={selected} handleSearch={handleSearch} searchText={searchText} numSelected={selected.length} />
                <TableContainer>
                    <Table
                        sx={{ minWidth: 750 }}
                        aria-labelledby="tableTitle"
                    >
                        <TableHead
                            numSelected={selected.length}
                            order={order}
                            orderBy={orderBy}
                            onSelectAllClick={handleSelectAllClick}
                            onRequestSort={handleRequestSort}
                            rowCount={filteredRows.length}
                        />
                        {/* <TableBody> */}
                        {/* if you don't need to support IE11, you can replace the `stableSort` call with:
                   filteredRows.slice().sort(getComparator(order, orderBy)) */}
                        {filteredRows.length > 0 && stableSort(filteredRows, getComparator(order, orderBy))
                            .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                            .map((row, index) => {
                                const isItemSelected = isSelected(row.id);
                                const labelId = `enhanced-table-checkbox-${index}`;
                                if (row.role === 'Driver') {
                                    lineChartDataResponseTime.dataLine.datasets.push({
                                        label: "",
                                        fill: true,
                                        lineTension: 0.3,
                                        backgroundColor: "rgba(225, 204,230, .3)",
                                        borderColor: "rgb(205, 130, 158)",
                                        borderCapStyle: "butt",
                                        borderDash: [],
                                        borderDashOffset: 0.0,
                                        borderJoinStyle: "miter",
                                        pointBorderColor: "rgb(205, 130,1 58)",
                                        pointBackgroundColor: "rgb(255, 255, 255)",
                                        pointBorderWidth: 10,
                                        pointHoverRadius: 5,
                                        pointHoverBackgroundColor: "rgb(0, 0, 0)",
                                        pointHoverBorderColor: "rgba(220, 220, 220,1)",
                                        pointHoverBorderWidth: 2,
                                        pointRadius: 1,
                                        pointHitRadius: 10,
                                        data: row.generateDataSetsAverageResponseTime(),
                                    });
                                    lineChartDataCommuteTime.dataLine.datasets.push({
                                        label: "",
                                        fill: true,
                                        lineTension: 0.3,
                                        backgroundColor: "rgba(184, 185, 210, .3)",
                                        borderColor: "rgb(35, 26, 136)",
                                        borderCapStyle: "butt",
                                        borderDash: [],
                                        borderDashOffset: 0.0,
                                        borderJoinStyle: "miter",
                                        pointBorderColor: "rgb(35, 26, 136)",
                                        pointBackgroundColor: "rgb(255, 255, 255)",
                                        pointBorderWidth: 10,
                                        pointHoverRadius: 5,
                                        pointHoverBackgroundColor: "rgb(0, 0, 0)",
                                        pointHoverBorderColor: "rgba(220, 220, 220, 1)",
                                        pointHoverBorderWidth: 2,
                                        pointRadius: 1,
                                        pointHitRadius: 10,
                                        data: row.generateDataSetsAverageCommuteTime(),
                                    });
                                }
                                return (
                                    <TableBody key={row.id}>
                                        <TableRow
                                            role="checkbox"
                                            aria-checked={isItemSelected}
                                            tabIndex={-1}
                                            selected={isItemSelected}
                                        >
                                            <TableCell padding="checkbox">
                                                <Checkbox
                                                    onClick={(event) => handleClick(event, row.id)}
                                                    color="primary"
                                                    checked={isItemSelected}
                                                    inputProps={{ 'aria-labelledby': labelId }}
                                                    onChange={_ => { }}
                                                />
                                            </TableCell>
                                            <TableCell
                                                component="th"
                                                id={labelId}
                                                scope="row"
                                                padding="none"
                                            >
                                                {row.name}
                                            </TableCell>
                                            <TableCell>{row.email}</TableCell>
                                            <TableCell>{row.contactNumber}</TableCell>
                                            <TableCell>
                                                {row.accountSetup ? (
                                                    <CheckIcon />
                                                ) : (
                                                    <CloseIcon />
                                                )}
                                            </TableCell>
                                            <TableCell>{row.role}</TableCell>
                                            <TableCell>
                                                {row.isActive ? (
                                                    <CheckIcon />
                                                ) : (
                                                    <CloseIcon />
                                                )}
                                            </TableCell>
                                            <TableCell>
                                                {
                                                    row.accountSetup ? (
                                                        <IconButton
                                                            aria-label="expand row"
                                                            size="small"
                                                            onClick={() => {
                                                                const openArray = [...open];
                                                                openArray[index] = !openArray[index];
                                                                setOpen(openArray);
                                                            }}
                                                        >
                                                            {open[index] ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
                                                        </IconButton>
                                                    ) : null
                                                }
                                            </TableCell>
                                        </TableRow>
                                        <TableRow>
                                            <TableCell style={{ paddingBottom: 0, paddingTop: 0 }} colSpan={8}>
                                                {
                                                    row.accountSetup ? (
                                                        <Collapse in={open[index]} timeout="auto" unmountOnExit>
                                                            <Container sx={{ margin: 1 }}>
                                                                {
                                                                    row.role === 'Driver' ? (
                                                                        <>
                                                                            <Row>
                                                                                <Col md={6}>
                                                                                    <Line options={optionsResponseTime} data={lineChartDataResponseTime.dataLine} />
                                                                                </Col>
                                                                                <Col md={6}>
                                                                                    <Line options={optionsCommuteTime} data={lineChartDataCommuteTime.dataLine} />
                                                                                </Col>
                                                                            </Row>
                                                                            <Row>
                                                                                <Col md={12}>
                                                                                    <Bar options={optionsBarChart} data={dataBarChart} />
                                                                                </Col>
                                                                            </Row>
                                                                            <Row>
                                                                                <Col md={12}>
                                                                                    <Typography variant="h6" gutterBottom component="div">
                                                                                        Trips
                                                                                    </Typography>
                                                                                    <Table size="small" aria-label="trips">
                                                                                        <MuiHead>
                                                                                            <TableRow>
                                                                                                <TableCell>Start location details</TableCell>
                                                                                                <TableCell>End location details</TableCell>
                                                                                                <TableCell>Patient</TableCell>
                                                                                                <TableCell>Ambulance number plate</TableCell>
                                                                                                <TableCell>Response time</TableCell>
                                                                                                <TableCell>Commute time</TableCell>
                                                                                            </TableRow>
                                                                                        </MuiHead>
                                                                                        <TableBody>
                                                                                            {row.trips.map((trip) => (
                                                                                                <TableRow key={trip._id}>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        <span className="bold-600">Start location from acceptance: </span> <br />
                                                                                                        <span>{trip.startLocationFromAcceptance.name}</span>
                                                                                                        <br />
                                                                                                        <span className="bold-600">Start Date/time from acceptance: </span> <br />
                                                                                                        <span>{convertDateTime(trip.startTimeFromAcceptance)}</span>
                                                                                                        <br />
                                                                                                        <span className="bold-600">Start location from patient: </span> <br />
                                                                                                        <span>{trip.startLocation.name}</span>
                                                                                                        <br />
                                                                                                        <span className="bold-600">Start Date/time from patient: </span> <br />
                                                                                                        <span>{convertDateTime(trip.startTime)}</span>
                                                                                                        <br />
                                                                                                    </TableCell>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        <span className="bold-600">End location: </span> <br />
                                                                                                        <span>{trip.endLocation.name}</span>
                                                                                                        <br />
                                                                                                        <span className="bold-600">End Date/time: </span> <br />
                                                                                                        <span>{convertDateTime(trip.endTime)}</span>
                                                                                                        <br />
                                                                                                    </TableCell>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        {trip.patient.firstName} {trip.patient.lastName}
                                                                                                    </TableCell>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        {trip.ambulance.numberPlate}
                                                                                                    </TableCell>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        {trip.responseTime} minutes
                                                                                                    </TableCell>
                                                                                                    <TableCell component="th" scope="row">
                                                                                                        {trip.commuteTime} minutes
                                                                                                    </TableCell>
                                                                                                </TableRow>
                                                                                            ))}
                                                                                        </TableBody>
                                                                                        <TableFooter>
                                                                                            <TableRow>
                                                                                                <TablePagination
                                                                                                    rowsPerPageOptions={[5]}
                                                                                                    colSpan={6}
                                                                                                    count={row.trips.length}
                                                                                                    rowsPerPage={5}
                                                                                                    page={page}
                                                                                                    SelectProps={{
                                                                                                        inputProps: {
                                                                                                            'aria-label': 'rows per page',
                                                                                                        },
                                                                                                    }}
                                                                                                    onPageChange={e => { }}
                                                                                                // ActionsComponent={TablePaginationActions}
                                                                                                />
                                                                                            </TableRow>
                                                                                        </TableFooter>
                                                                                    </Table>
                                                                                </Col>
                                                                            </Row>
                                                                        </>
                                                                    ) : null
                                                                }
                                                                {
                                                                    row.role === 'Patient' ? (
                                                                        <>
                                                                            <Row className='margin-global-top-1'>
                                                                                <Col md={6}>
                                                                                    <Typography variant="h6" gutterBottom component="div">
                                                                                        Medical Card
                                                                                    </Typography>
                                                                                </Col>
                                                                            </Row>
                                                                            <Row>
                                                                                <Col md={6}>
                                                                                    <span className="bold-600">Age: </span>{row.medicalCard.age} years old <br />
                                                                                    <span className="bold-600">Blood Group: </span>{row.medicalCard.bloodGroup} <br />
                                                                                    <span className="bold-600">Height: </span>{row.medicalCard.height} cm <br />
                                                                                    <span className="bold-600">Weight: </span>{row.medicalCard.weight} kg <br />
                                                                                    <br />
                                                                                    <span className="bold-600">Allergies: </span> <br />
                                                                                    {row.medicalCard.allergies.map((allergy, index) => (
                                                                                        <span key={index}>
                                                                                            Name: {allergy.name} <br />
                                                                                            Severity: {allergy.severity} <br />
                                                                                            Reaction: {allergy.reaction} <br /><br />
                                                                                        </span>
                                                                                    ))}
                                                                                </Col>
                                                                                <Col md={6}>
                                                                                    <span className="bold-600">Medications: </span> <br />
                                                                                    {row.medicalCard.medications.map((medication, index) => (
                                                                                        <span key={index}>
                                                                                            Name: {medication.name} <br />
                                                                                            Dose: {medication.dose} <br />
                                                                                            Frequency: {medication.frequency} <br /><br />
                                                                                        </span>
                                                                                    ))}
                                                                                </Col>
                                                                            </Row>
                                                                            <Row>
                                                                                <Col md={6}>
                                                                                    <span className="bold-600">Medical History: </span> <br />
                                                                                    {row.medicalCard.medicalHistories.map((history, index) => (
                                                                                        <span key={index}>
                                                                                            Description: {history.description} <br />
                                                                                            Date: {convertDateTime(history.date)} <br />
                                                                                            Doctor: {history.doctor} <br />
                                                                                            Hospital: {history.hospital} <br /><br />
                                                                                        </span>
                                                                                    ))}
                                                                                </Col>
                                                                                <Col md={6}>
                                                                                    <span className="bold-600">Vaccinations: </span> <br />
                                                                                    {row.medicalCard.vaccinations.map((vaccination, index) => (
                                                                                        <span key={index}>
                                                                                            Name: {vaccination.name} <br />
                                                                                            Date: {convertDateTime(vaccination.date)} <br />
                                                                                            Doctor: {vaccination.doctor} <br />
                                                                                            Hospital: {vaccination.hospital} <br /><br />
                                                                                        </span>
                                                                                    ))}
                                                                                </Col>
                                                                            </Row>
                                                                            <Row>
                                                                                <Col md={6}>
                                                                                    <span className="bold-600">Family History: </span> <br />
                                                                                    {row.medicalCard.familyHistories.map((history, index) => (
                                                                                        <span key={index}>
                                                                                            Name: {history.name} <br />
                                                                                            Description: {history.description} <br /> <br />
                                                                                        </span>
                                                                                    ))}
                                                                                </Col>
                                                                            </Row>
                                                                        </>
                                                                    ) : null
                                                                }
                                                            </Container>
                                                        </Collapse>
                                                    ) : null
                                                }
                                            </TableCell>
                                        </TableRow>
                                    </TableBody>
                                );
                            })}
                        {emptyRows > 0 && (
                            <TableRow>
                                <TableCell colSpan={6} />
                            </TableRow>
                        )}
                        {/* </TableBody> */}
                    </Table>
                </TableContainer>
                <TablePagination
                    rowsPerPageOptions={[5, 10, 25]}
                    component="div"
                    count={filteredRows.length}
                    rowsPerPage={rowsPerPage}
                    page={page}
                    onPageChange={handleChangePage}
                    onRowsPerPageChange={handleChangeRowsPerPage}
                />
            </Paper>
        </Box>
    );
}