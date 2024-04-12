import React from 'react';
import MyCalendar from '../components/calendar';
import NavCluster from '../components/navCluster';
import ListView from '../components/listView';

export default class Dashboard extends React.Component {
    // Define your events array
    events=[
        // ways to format the data
        {title: 'Goon', start: '2024-04-10T10:00:00', end: '2024-04-10T12:00:00', color: '#ff9f89'},
        {title: 'test day', date: '2024-04-13', color: '#ff9f89'},
    ]

    render() {
        return (
            <div style={{
                display: 'flex',
                flexDirection: 'column',
                height: '100vh',
                overflow: 'hidden',
            }}>
                <NavCluster user={{ role: 'superAdmin' }} />
                <div style={{
                        textAlign: 'center',
                    }}>
                        <h1>Welcome, USERNAME</h1>
                </div>
                <div style={{
                    display: 'flex',
                    flex: 1,
                    justifyContent: 'space-around',
                    padding: '20px 0',
                }}>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Calendar</h1>
                        <MyCalendar events={this.events}/>
                    </div>
                    <div style={{ width: '45%' }}>
                        <h1 style={{ textAlign: 'center' }}>Upcoming Events</h1>
                        <ListView events={this.events} />
                    </div>
                </div>
            </div>
        );
    }
}