import React from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { AppStoreDownloadLink } from '../../../../components';
import './Section1.scss';

function Section1(props) {
    return (
        <div className='section1-main'>
            <div className='section1'>
                <img src='/background.png' className='section1-bg' alt='' />
                <img className='logo unhide-1100' src="/Tezz_Logo_T_W(1).png" alt='Tezz' />
                <Container fluid>
                    <Container>
                        <Row className='justify-content-center hide-1100'>
                            <Col lg={7} className='margin-global-top-2'>
                                <img className='logo' src="/Tezz_Logo_T_W(1).png" alt='Tezz' />
                            </Col>
                            <Col lg={5} />
                        </Row>
                        <Row className='justify-content-center margin-global-top-4 hide-1100-pe'>
                            <Col lg={7}>
                                <h1>Coming Soon</h1>
                                <p>To your App Stores</p>
                                <Row className='justify-content-start'>
                                    <Col xs={4}>
                                        <AppStoreDownloadLink
                                            imagePath='/Apple-Store.png'
                                        />
                                    </Col>
                                    <Col xs={4}>
                                        <AppStoreDownloadLink
                                            imagePath='/Google-Play.png'
                                        />
                                    </Col>
                                </Row>
                            </Col>
                            <Col lg={5} className='mobile-cont'>
                                <img className='mobile' src="/Main-Page-Mobile(Blue).png" alt='Tezz mobiles' />
                            </Col>
                        </Row>
                    </Container>
                </Container>
            </div>
            <Container fluid>
                <Row className='justify-content-center margin-global-top-4 unhide-1100'>
                    <Col lg={7} className='center-relative-horizontal'>
                        <h1>Coming Soon</h1>
                        <p>To your App Stores</p>
                        <Row className='justify-content-start'>
                            <Col xs={4}>
                                <AppStoreDownloadLink
                                    imagePath='/Apple-Store.png'
                                />
                            </Col>
                            <Col xs={4}>
                                <AppStoreDownloadLink
                                    imagePath='/Google-Play.png'
                                />
                            </Col>
                        </Row>
                    </Col>
                </Row>
                {/* <div className='margin-global-top-4 unhide-1100' /> */}
            </Container>
        </div>
    );
}

export default Section1;