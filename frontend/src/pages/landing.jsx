import React from 'react';
import MyCalendar from '../components/calendar';

export default class Landing extends React.Component {
    // Define your events array
    events=[
        { title: 'event 1', date: '2024-04-01' },
        { title: 'event 2', date: '2024-04-02' }
    ]

    render() {
        return (
            <div>
                <MyCalendar events={this.events} /> {/* Use this.events to access the events array */}
            </div>
        );
    }
}
