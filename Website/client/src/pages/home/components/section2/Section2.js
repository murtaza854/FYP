import React from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import './Section2.scss';

function Section2(props) {
    return (
        <Container className='section2'>
            <Row className='justify-content-center section2-center'>
                <Col md={6} className='col-full'>
                    <Row>
                        <Col md={12}>
                            <img src="/Tezz_Logo_B(T)(2).png" alt="Tezz Logo" className='tezz-logo' />
                        </Col>
                    </Row>
                    <Row>
                        <Col md={12}>
                            <img src="/Chat-Bubbles(Blue).png" alt='chat-bubbles' className='chat-bubbles' />
                        </Col>
                    </Row>
                    <Row className='hide-1100'>
                        <Col md={12}>
                            <img src="/Chat-Screen.png" alt='chat-Screen' className='chat-screen' />
                        </Col>
                    </Row>
                </Col>
                <Col md={6} className='col-full'>
                    <div className='margin-global-top-7 center-relative-horizontal-fit-content'>
                        <h1>
                            <span>Save</span> Lives <br />
                            With <span>Tezz</span>
                        </h1>
                        <p>
                            We Aim to make the Ambulance <br />
                            Hailing system Hassle free and <br />
                            Non - Verbal with the use of <br />
                            Technology <br />
                        </p>
                    </div>
                </Col>
            </Row>
        </Container>
    );
}

export default Section2;