import React from 'react';
import { Col, Row } from 'react-bootstrap';
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

function Dash(props) {

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
        data: [65, 59, 80, 81, 56, 55, 40]
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
        data: [28, 48, 40, 19, 86, 27, 90]
    });
    return (
        <div>
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
        </div >
    );
}

export default Dash;