import React from 'react';
import Calendar from '../components/calendar';

export default class Landing extends React.Component {
    // Define your events array
    events=[
        { title: 'event 1', date: '2024-04-01' },
        { title: 'event 2', date: '2024-04-02' }
    ]

    render() {
        return (
            <div>
                <Calendar events={this.events} /> {/* Use this.events to access the events array */}
                <div>
                    <h1>Hello, World!</h1>
                </div>
            </div>
        );
    }
}
