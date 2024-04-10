import React from 'react';
import Calendar from '../components/calendar';
import MyCalendar from '../components/calendar2';


export default class Test extends React.Component {
    // Define your events array
    events=[
        { title: 'event 1', date: '2024-04-01' },
        { title: 'event 2', date: '2024-04-02' }
    ]

    render() {
        return (
            <div>
                {/* <Calendar events={this.events} /> */}
                <MyCalendar />
            </div>
        );
    }
}
