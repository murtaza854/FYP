import React from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import './Section3.scss';

function Section3(props) {
    return (
        <Container fluid className='section3'>
            <Row className='justify-content-end'>
                <Col md={4}>
                    <ul>
                        <li>First-Aid Tips</li>
                        <li>Real Time GPS Tracking</li>
                        <li>Estimated Time of Arrival</li>
                        <li>SOS Notifications to Emergency Contacts</li>
                        <li>Add Family & Friends as Emergency Contacts</li>
                        <li>Bi-Lingual Support (English & Urdu)</li>
                    </ul>
                </Col>
                <Col md={6}>
                    <img src="/Other-Tezz-Features(Blue).png" alt="Tezz Logo" className='tezz-features' />
                </Col>
            </Row>
        </Container>
    );
}

export default Section3;