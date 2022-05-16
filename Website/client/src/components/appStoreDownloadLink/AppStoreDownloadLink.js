import React from 'react';
import { Link } from 'react-router-dom';
import './AppStoreDownloadLink.scss';

function AppStoreDownloadLink(props) {
    return (
        <Link href='/' className='app-store-download'>
            <img src={props.imagePath} alt='Download on the App Store' />
        </Link>
    );
}

export default AppStoreDownloadLink;