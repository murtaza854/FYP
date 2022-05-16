import React from 'react';
import './Heading.scss';

function Heading(props) {
    return (
        <div className='heading'>
            <img src="/Tezz_Logo_B(T)(2).png" alt="Tezz Logo" className='tezz-logo1' />
            <h1>
                {props.first} <span>{props.second}</span> {props.third}
            </h1>
            <div style={{ textAlign: 'end' }}>
                <img src="/Tezz_Logo_B(T)(2).png" alt="Tezz Logo" className='tezz-logo2' />
            </div>
        </div>
    );
}

export default Heading;