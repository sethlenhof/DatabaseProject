import React from 'react';
import MyCalendar from '../components/calendar';
import NavCluster from '../components/navCluster';

export default class Landing extends React.Component {
    // Define your events array
    events=[
        // ways to format the data
        {title: 'Goon', start: '2024-04-10T10:00:00', end: '2024-04-10T12:00:00', color: '#ff9f89'},
        {title: 'test day', date: '2024-04-13', color: '#ff9f89'},
    ]

    render() {
        return (
            <>
                <NavCluster user={{role: 'admin'}} />
                <div
                    style={{
                        display: 'flex',
                        justifyContent: 'center',
                        alignItems: 'center',
                        height: '100vh'
                    }}>
                    <h1>Calendar Stuff</h1>
                </div>
            </>
        );
    }
}
