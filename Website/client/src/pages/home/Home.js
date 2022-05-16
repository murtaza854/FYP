import React from 'react';
import { Heading } from '../../components';
import { Section1, Section2, Section3 } from './components';
import './Home.scss';

function Home(props) {
    return (
        <div className='home'>
            <Section1 />
            <div className="margin-global-top--2 hide-1100" />
            <Section2 />
            <Heading
                first='Other'
                second='Tezz'
                third='Features'
            />
            <Section3 />
        </div>
    );
}

export default Home;